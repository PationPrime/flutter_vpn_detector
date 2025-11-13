#include "include/vpn_checker/vpn_checker_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For WMI and network detection
#include <wbemidl.h>
#include <comdef.h>
#include <iphlpapi.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <string>
#include <vector>

#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "wbemuuid.lib")

namespace vpn_checker {

// Static method to register the plugin
void VpnCheckerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "vpn_checker",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<VpnCheckerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

VpnCheckerPlugin::VpnCheckerPlugin() {}

VpnCheckerPlugin::~VpnCheckerPlugin() {}

void VpnCheckerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("isVpnActive") == 0) {
    bool isActive = IsVpnActive();
    result->Success(flutter::EncodableValue(isActive));
  } else {
    result->NotImplemented();
  }
}

bool VpnCheckerPlugin::IsVpnActive() {
  // Method 1: Check network adapters using IP Helper API
  if (CheckVpnByNetworkAdapters()) {
    return true;
  }

  // Method 2: Check for VPN interfaces by description
  if (CheckVpnByInterfaceDescription()) {
    return true;
  }

  return false;
}

bool VpnCheckerPlugin::CheckVpnByNetworkAdapters() {
  ULONG bufferSize = 15000;
  std::vector<BYTE> buffer(bufferSize);
  PIP_ADAPTER_ADDRESSES pAddresses = reinterpret_cast<PIP_ADAPTER_ADDRESSES>(buffer.data());

  ULONG result = GetAdaptersAddresses(
      AF_UNSPEC,
      GAA_FLAG_INCLUDE_PREFIX | GAA_FLAG_SKIP_MULTICAST | GAA_FLAG_SKIP_ANYCAST,
      nullptr,
      pAddresses,
      &bufferSize);

  if (result == ERROR_BUFFER_OVERFLOW) {
    buffer.resize(bufferSize);
    pAddresses = reinterpret_cast<PIP_ADAPTER_ADDRESSES>(buffer.data());
    result = GetAdaptersAddresses(
        AF_UNSPEC,
        GAA_FLAG_INCLUDE_PREFIX | GAA_FLAG_SKIP_MULTICAST | GAA_FLAG_SKIP_ANYCAST,
        nullptr,
        pAddresses,
        &bufferSize);
  }

  if (result != NO_ERROR) {
    return false;
  }

  // VPN interface keywords to search for
  std::vector<std::wstring> vpnKeywords = {
      L"vpn", L"virtual", L"tap", L"tun", L"pptp", L"l2tp",
      L"ipsec", L"wireguard", L"openvpn", L"cisco", L"anyconnect",
      L"fortinet", L"sonicwall", L"palo alto", L"checkpoint"
  };

  PIP_ADAPTER_ADDRESSES pCurrAddresses = pAddresses;
  while (pCurrAddresses) {
    // Check if adapter is up and not loopback
    if (pCurrAddresses->OperStatus == IfOperStatusUp &&
        pCurrAddresses->IfType != IF_TYPE_SOFTWARE_LOOPBACK) {
      
      // Convert adapter description to lowercase for comparison
      std::wstring description = pCurrAddresses->Description;
      std::transform(description.begin(), description.end(), description.begin(), ::towlower);

      // Check if description contains VPN keywords
      for (const auto& keyword : vpnKeywords) {
        if (description.find(keyword) != std::wstring::npos) {
          return true;
        }
      }

      // Check adapter name
      std::wstring friendlyName = pCurrAddresses->FriendlyName;
      std::transform(friendlyName.begin(), friendlyName.end(), friendlyName.begin(), ::towlower);
      
      for (const auto& keyword : vpnKeywords) {
        if (friendlyName.find(keyword) != std::wstring::npos) {
          return true;
        }
      }

      // Check if it's a tunnel interface (common for VPNs)
      if (pCurrAddresses->IfType == IF_TYPE_TUNNEL) {
        return true;
      }
    }

    pCurrAddresses = pCurrAddresses->Next;
  }

  return false;
}

bool VpnCheckerPlugin::CheckVpnByInterfaceDescription() {
  ULONG bufferSize = 0;
  std::vector<BYTE> buffer;

  // Get required buffer size
  if (GetInterfaceInfo(nullptr, &bufferSize) != ERROR_INSUFFICIENT_BUFFER) {
    return false;
  }

  buffer.resize(bufferSize);
  PIP_INTERFACE_INFO pInfo = reinterpret_cast<PIP_INTERFACE_INFO>(buffer.data());

  if (GetInterfaceInfo(pInfo, &bufferSize) != NO_ERROR) {
    return false;
  }

  // Check each interface
  for (int i = 0; i < pInfo->NumAdapters; i++) {
    std::wstring name = pInfo->Adapter[i].Name;
    std::transform(name.begin(), name.end(), name.begin(), ::towlower);

    // Check for VPN-related keywords in interface name
    if (name.find(L"vpn") != std::wstring::npos ||
        name.find(L"tun") != std::wstring::npos ||
        name.find(L"tap") != std::wstring::npos ||
        name.find(L"ppp") != std::wstring::npos) {
      return true;
    }
  }

  return false;
}

}  // namespace vpn_checker

