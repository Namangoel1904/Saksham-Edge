package com.example.beingnotified.ui.screens

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.osmdroid.config.Configuration
import org.osmdroid.tileprovider.tilesource.TileSourceFactory
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker
import org.osmdroid.views.overlay.Polyline

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RouteMapScreen(
    viewModel: MainViewModel,
    onNavigateBack: () -> Unit
) {
    val retailers by viewModel.retailers.collectAsStateWithLifecycle()
    val context = LocalContext.current

    LaunchedEffect(Unit) {
        Configuration.getInstance().userAgentValue = context.packageName
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Saksham Edge - Route") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { padding ->
        AndroidView(
            modifier = Modifier.fillMaxSize().padding(padding),
            factory = { ctx ->
                MapView(ctx).apply {
                    setTileSource(TileSourceFactory.MAPNIK)
                    controller.setZoom(7.0)
                    controller.setCenter(GeoPoint(18.5204, 73.8567))
                    setMultiTouchControls(true)
                }
            },
            update = { mapView ->
                mapView.overlays.clear()
                
                val pune = GeoPoint(18.5204, 73.8567)
                val topRetailers = retailers.sortedByDescending { it.priorityScore }.take(15)
                
                topRetailers.forEach { retailer ->
                    val marker = Marker(mapView)
                    marker.position = GeoPoint(retailer.lat, retailer.lng)
                    marker.title = "${retailer.name} (Score: ${retailer.priorityScore})"
                    mapView.overlays.add(marker)
                }

                if (topRetailers.isNotEmpty()) {
                    val line = Polyline(mapView)
                    line.addPoint(pune)
                    topRetailers.forEach { retailer ->
                        line.addPoint(GeoPoint(retailer.lat, retailer.lng))
                    }
                    line.color = android.graphics.Color.BLUE
                    line.width = 5f
                    mapView.overlays.add(line)
                }

                mapView.invalidate()
            }
        )
    }
}
