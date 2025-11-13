#include "include/vpn_checker/vpn_checker_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

#define VPN_CHECKER_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), vpn_checker_plugin_get_type(), \
                               VpnCheckerPlugin))

struct _VpnCheckerPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(VpnCheckerPlugin, vpn_checker_plugin, g_object_get_type())

// VPN interface patterns
static const std::vector<std::string> VPN_INTERFACE_PATTERNS = {
    "tun", "tap", "ppp", "pptp", "l2tp", "ipsec",
    "wireguard", "wg", "openvpn", "vpn", "utun"
};

// VPN route patterns
static const std::vector<std::string> VPN_ROUTE_PATTERNS = {
    "tun", "tap", "ppp", "wg", "vpn"
};

// Check if VPN is active by checking network interfaces
static bool check_vpn_by_network_interfaces() {
  std::ifstream file("/proc/net/dev");
  if (!file.is_open()) {
    return false;
  }

  std::string line;
  // Skip the first two header lines
  std::getline(file, line);
  std::getline(file, line);

  while (std::getline(file, line)) {
    // Extract interface name (before the colon)
    size_t colonPos = line.find(':');
    if (colonPos == std::string::npos) {
      continue;
    }

    std::string interfaceName = line.substr(0, colonPos);
    // Trim whitespace
    interfaceName.erase(0, interfaceName.find_first_not_of(" \t"));
    interfaceName.erase(interfaceName.find_last_not_of(" \t") + 1);

    // Convert to lowercase for comparison
    std::string lowerName = interfaceName;
    std::transform(lowerName.begin(), lowerName.end(), lowerName.begin(), ::tolower);

    // Check if interface name matches VPN patterns
    for (const auto& pattern : VPN_INTERFACE_PATTERNS) {
      if (lowerName.find(pattern) != std::string::npos) {
        // Additional check: verify the interface is UP by checking if it has traffic
        // Parse the line to get receive and transmit bytes
        std::istringstream iss(line.substr(colonPos + 1));
        long long rxBytes, rxPackets, txBytes, txPackets;
        iss >> rxBytes >> rxPackets;
        // Skip some fields
        for (int i = 0; i < 6; i++) {
          long long temp;
          iss >> temp;
        }
        iss >> txBytes >> txPackets;

        // If interface has any traffic or is simply present, consider it active
        // (even 0 bytes can indicate an active VPN interface that's just been started)
        return true;
      }
    }
  }

  return false;
}

// Check if VPN is active by checking routing table
static bool check_vpn_by_route_table() {
  std::ifstream file("/proc/net/route");
  if (!file.is_open()) {
    return false;
  }

  std::string line;
  // Skip header line
  std::getline(file, line);

  while (std::getline(file, line)) {
    // Extract interface name (first column)
    std::istringstream iss(line);
    std::string interfaceName;
    iss >> interfaceName;

    // Convert to lowercase for comparison
    std::string lowerName = interfaceName;
    std::transform(lowerName.begin(), lowerName.end(), lowerName.begin(), ::tolower);

    // Check if interface name matches VPN patterns
    for (const auto& pattern : VPN_ROUTE_PATTERNS) {
      if (lowerName.find(pattern) != std::string::npos) {
        return true;
      }
    }
  }

  return false;
}

// Check if VPN is active
static bool is_vpn_active() {
  // Method 1: Check network interfaces
  if (check_vpn_by_network_interfaces()) {
    return true;
  }

  // Method 2: Check routing table
  if (check_vpn_by_route_table()) {
    return true;
  }

  return false;
}

// Called when a method call is received from Flutter.
static void vpn_checker_plugin_handle_method_call(
    VpnCheckerPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "isVpnActive") == 0) {
    bool isActive = is_vpn_active();
    g_autoptr(FlValue) result = fl_value_new_bool(isActive);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void vpn_checker_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(vpn_checker_plugin_parent_class)->dispose(object);
}

static void vpn_checker_plugin_class_init(VpnCheckerPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = vpn_checker_plugin_dispose;
}

static void vpn_checker_plugin_init(VpnCheckerPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                            gpointer user_data) {
  VpnCheckerPlugin* plugin = VPN_CHECKER_PLUGIN(user_data);
  vpn_checker_plugin_handle_method_call(plugin, method_call);
}

void vpn_checker_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  VpnCheckerPlugin* plugin = VPN_CHECKER_PLUGIN(
      g_object_new(vpn_checker_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "vpn_checker",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                             g_object_ref(plugin),
                                             g_object_unref);

  g_object_unref(plugin);
}

