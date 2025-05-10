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

        if (preState == networkConnectionState) {
            return
        }

        preState = networkConnectionState

        emitSignal("stateChanged", "$networkConnectionState")
    }

    @UsedByGodot
    private fun isNetworkConnected(): Boolean {
        val connectionManager = activity?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectionManager.activeNetwork

        val networkCapabilities = connectionManager.getNetworkCapabilities(activeNetwork)

        return networkCapabilities != null &&
                (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                        networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI))
    }
}
