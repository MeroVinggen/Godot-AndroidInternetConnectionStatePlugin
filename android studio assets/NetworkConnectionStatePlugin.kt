package io.github.mero.networkconnectionstate


import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Handler
import android.os.Looper
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot


class NetworkConnectionStatePlugin(godot: Godot): GodotPlugin(godot) {

    override fun getPluginName() = "AndroidInternetConnectionStatePlugin"

    private var stateUpdateDelay: Long = 1500
    private var preState: Boolean = false
    private var preNetworkType: String = ""

    private val handler = Handler(Looper.getMainLooper())
    private val emitStateRunnable = Runnable {
        emitCurrentState()
    }

    init {
        registerNetworkCallback()
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = mutableSetOf()
        signals.add(SignalInfo("stateChanged", String::class.java))
        signals.add(SignalInfo("networkTypeChanged", String::class.java))
        return signals
    }

    private fun registerNetworkCallback() {
        val connectionManager = activity?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkRequest = NetworkRequest.Builder()
            .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR)
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
            .build()

        connectionManager.registerNetworkCallback(networkRequest,
            object: ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    super.onAvailable(network)
                    handler.removeCallbacks(emitStateRunnable)
                    handler.postDelayed(emitStateRunnable, stateUpdateDelay)
                }

                override fun onLost(network: Network) {
                    super.onLost(network)
                    handler.removeCallbacks(emitStateRunnable)
                    handler.postDelayed(emitStateRunnable, stateUpdateDelay)
                }
            })
    }

    private fun emitCurrentState() {
        val networkConnectionState = isNetworkConnected()
        val currentNetworkType = getActiveNetworkType()

        if (preState != networkConnectionState) {
            preState = networkConnectionState
            emitSignal("stateChanged", "$networkConnectionState")
        }

        if (preNetworkType != currentNetworkType) {
            preNetworkType = currentNetworkType
            emitSignal("networkTypeChanged", currentNetworkType)
        }
    }

    @UsedByGodot
    private fun isNetworkConnected(): Boolean {
        return getActiveNetworkType() != "NONE"
    }

    @UsedByGodot
    private fun getActiveNetworkType(): String {
        val connectionManager = activity?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectionManager.activeNetwork
        val networkCapabilities = connectionManager.getNetworkCapabilities(activeNetwork)

        if (networkCapabilities != null && networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
            // Check for WiFi
            if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                return "WIFI"
            }

            // Check for Cellular
            if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                return "CELLULAR"
            }

            // Check for Ethernet
            if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
                return "ETHERNET"
            }
        }

        return "NONE"
    }
}
