package com.tikoua.vpn_checker

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.util.Locale

/** VpnCheckerPlugin */
class VpnCheckerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    companion object {
        // VPN interface name patterns
        private val VPN_INTERFACE_PATTERNS = listOf(
            "tun", "tap", "ppp", "pptp", "l2tp", "ipsec",
            "wireguard", "wg", "openvpn", "vpn", "utun",
            "ppp0", "ppp1", "tun0", "tun1", "wg0", "wg1"
        )

        // VPN route patterns
        private val VPN_ROUTE_PATTERNS = listOf("tun", "tap", "ppp", "wg", "vpn")

        // Route file path
        private const val ROUTE_FILE_PATH = "/proc/net/route"
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vpn_checker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isVpnActive" -> {
                scope.launch {
                    try {
                        val isActive = checkVpn()
                        withContext(Dispatchers.Main) {
                            result.success(isActive)
                        }
                    } catch (e: Exception) {
                        withContext(Dispatchers.Main) {
                            result.error("VPN_CHECK_ERROR", e.message, null)
                        }
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Check if VPN is active using multiple detection methods
     */
    private suspend fun checkVpn(): Boolean = withContext(Dispatchers.IO) {
        // Method 1: Use ConnectivityManager API (Android 6.0+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkVpnByConnectivityManager()) {
                return@withContext true
            }
        }

        // Method 2: Check network interface names (compatible with all API levels)
        if (checkVpnByNetworkInterface()) {
            return@withContext true
        }

        // Method 3: Check routing table (auxiliary detection)
        if (checkVpnByRoute()) {
            return@withContext true
        }

        return@withContext false
    }

    /**
     * Check VPN using ConnectivityManager (Android 6.0+)
     */
    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkVpnByConnectivityManager(): Boolean {
        return try {
            val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
                ?: return false

            val networks = connectivityManager.allNetworks
            val activeNetwork = connectivityManager.activeNetwork

            for (network in networks) {
                val capabilities = connectivityManager.getNetworkCapabilities(network) ?: continue

                // Check if network has VPN transport type
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                    return true
                }

                // Check if NOT_VPN capability is missing (some VPN implementations may not set TRANSPORT_VPN)
                if (network != activeNetwork && !capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN)) {
                    // Exclude known transport types (WiFi, Cellular, etc.)
                    val hasKnownTransport = capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) ||
                            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_BLUETOOTH)

                    if (!hasKnownTransport) {
                        return true
                    }
                }
            }
            false
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Check VPN by network interface names
     */
    private fun checkVpnByNetworkInterface(): Boolean {
        return try {
            val networkInterfaces = java.net.NetworkInterface.getNetworkInterfaces()
            while (networkInterfaces.hasMoreElements()) {
                val networkInterface = networkInterfaces.nextElement()

                // Check interface name
                val name = networkInterface.name.lowercase(Locale.ROOT)
                if (isVpnInterface(name, networkInterface)) {
                    return true
                }

                // Check display name
                val displayName = try {
                    networkInterface.displayName?.lowercase(Locale.ROOT) ?: ""
                } catch (e: Exception) {
                    ""
                }
                if (displayName.isNotEmpty() && isVpnInterface(displayName, networkInterface)) {
                    return true
                }
            }
            false
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Check if interface name matches VPN pattern and interface is active
     */
    private fun isVpnInterface(interfaceName: String, networkInterface: java.net.NetworkInterface): Boolean {
        // Check if interface name contains VPN pattern
        if (!VPN_INTERFACE_PATTERNS.any { interfaceName.contains(it) }) {
            return false
        }

        // Check if interface is UP (active)
        val isUp = try {
            networkInterface.isUp
        } catch (e: Exception) {
            false
        }

        // Check if it's a loopback interface (exclude)
        val isLoopback = try {
            networkInterface.isLoopback
        } catch (e: Exception) {
            false
        }

        // If interface is UP and not loopback, it's likely a VPN
        return isUp && !isLoopback
    }

    /**
     * Check VPN by routing table (auxiliary method)
     */
    private fun checkVpnByRoute(): Boolean {
        return try {
            val routeFile = File(ROUTE_FILE_PATH)
            if (!routeFile.exists() || !routeFile.canRead()) {
                return false
            }

            val routes = routeFile.readText().lowercase(Locale.ROOT)

            // Check if routes contain any VPN pattern
            val foundPattern = VPN_ROUTE_PATTERNS.firstOrNull { routes.contains(it) }
            foundPattern != null
        } catch (e: Exception) {
            false
        }
    }
}

