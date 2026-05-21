package com.example.beingnotified.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.beingnotified.data.RetailerEntity

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    viewModel: MainViewModel,
    onNavigateToDetail: (String) -> Unit,
    onNavigateToMap: () -> Unit
) {
    val retailers by viewModel.retailers.collectAsStateWithLifecycle()
    var showVoiceSheet by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        viewModel.loadRetailers()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Saksham Edge") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    titleContentColor = Color.White,
                    actionIconContentColor = Color.White
                ),
                actions = {
                    IconButton(onClick = onNavigateToMap) {
                        Icon(Icons.Default.LocationOn, contentDescription = "Map")
                    }
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { showVoiceSheet = true },
                containerColor = MaterialTheme.colorScheme.secondary
            ) {
                Icon(Icons.Default.Mic, contentDescription = "Voice Assistant", tint = Color.White)
            }
        }
    ) { padding ->
        LazyColumn(
            contentPadding = padding,
            modifier = Modifier.fillMaxSize().padding(16.dp)
        ) {
            items(retailers) { retailer ->
                RetailerItem(retailer, onClick = { onNavigateToDetail(retailer.id) })
                Spacer(modifier = Modifier.height(8.dp))
            }
        }

        if (showVoiceSheet) {
            VoiceBottomSheet(
                retailerName = "Kisan Krishi Kendra",
                onDismiss = { showVoiceSheet = false }
            )
        }
    }
}

@Composable
fun RetailerItem(retailer: RetailerEntity, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .background(MaterialTheme.colorScheme.secondary.copy(alpha = 0.2f), CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = retailer.priorityScore.toString(),
                    color = MaterialTheme.colorScheme.secondary,
                    fontWeight = FontWeight.Bold
                )
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(retailer.name, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleMedium)
                Text("Inventory: ${retailer.inventoryLevel}", style = MaterialTheme.typography.bodyMedium)
                Text("Last Visited: ${retailer.lastVisited.split("T")[0]}", style = MaterialTheme.typography.bodySmall, color = Color.Gray)
            }
            Icon(Icons.Default.KeyboardArrowRight, contentDescription = "Details", tint = Color.Gray)
        }
    }
}
