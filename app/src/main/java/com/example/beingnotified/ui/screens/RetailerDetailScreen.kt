package com.example.beingnotified.ui.screens

import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RetailerDetailScreen(
    retailerId: String,
    viewModel: MainViewModel,
    onNavigateBack: () -> Unit
) {
    val retailers by viewModel.retailers.collectAsStateWithLifecycle()
    val retailer = retailers.find { it.id == retailerId }
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()
    
    var showVoiceSheet by remember { mutableStateOf(false) }
    var isScanning by remember { mutableStateOf(false) }
    
    val cameraLauncher = rememberLauncherForActivityResult(ActivityResultContracts.TakePicturePreview()) { bitmap ->
        if (bitmap != null) {
            coroutineScope.launch {
                isScanning = true
                delay(2000) // Simulate TinyML processing
                isScanning = false
                Toast.makeText(context, "Anomaly Detected: Competitor Promotion\nPriority Score +50", Toast.LENGTH_LONG).show()
                viewModel.boostPriority(retailerId, 50)
            }
        }
    }

    if (retailer == null) return

    val nbaText = if (retailer.inventoryLevel.lowercase() == "low") {
        "Pitch Syngenta Voliam Targo (Insecticide)"
    } else if (retailer.priorityScore >= 80) {
        "Discuss Bulk Discount on Amistar Top"
    } else {
        "Conduct Routine Inventory Check"
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(retailer.name) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
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
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
        ) {
            // NBA Card
            Card(
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primary),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(modifier = Modifier.padding(20.dp).fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Lightbulb, contentDescription = null, tint = Color(0xFFFFC107))
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Next Best Action", color = Color.White, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                    }
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(nbaText, color = Color.White, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.SemiBold)
                }
            }
            
            Spacer(modifier = Modifier.height(16.dp))

            // LIME AI Reasoning
            var expanded by remember { mutableStateOf(false) }
            Card(
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.fillMaxWidth()) {
                    Row(
                        modifier = Modifier.fillMaxWidth().clickable { expanded = !expanded }.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(Icons.Default.Psychology, contentDescription = null, tint = MaterialTheme.colorScheme.secondary)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("AI Reasoning (LIME)", fontWeight = FontWeight.Bold, modifier = Modifier.weight(1f))
                        Icon(if (expanded) Icons.Default.KeyboardArrowUp else Icons.Default.KeyboardArrowDown, contentDescription = null)
                    }
                    
                    AnimatedVisibility(visible = expanded) {
                        Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                            LimeFactor("+60% Weight:", "Satellite NDVI shows crop stress in a 5km radius.", Color(0xFF4CAF50))
                            Spacer(modifier = Modifier.height(12.dp))
                            LimeFactor("+30% Weight:", "Store inventory for Voliam Targo is critically low.", Color(0xFFFF9800))
                            Spacer(modifier = Modifier.height(12.dp))
                            LimeFactor("+10% Weight:", "Routine visit overdue.", Color(0xFF2196F3))
                        }
                    }
                }
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            Button(
                onClick = { cameraLauncher.launch(null) },
                modifier = Modifier.fillMaxWidth().height(56.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFF9800)),
                enabled = !isScanning
            ) {
                if (isScanning) {
                    CircularProgressIndicator(color = Color.White, modifier = Modifier.size(24.dp))
                    Spacer(modifier = Modifier.width(12.dp))
                    Text("Analyzing Edge ML Model...")
                } else {
                    Icon(Icons.Default.CameraAlt, contentDescription = null)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text("Anomaly Scanner (Edge Vision)")
                }
            }
        }
        
        if (showVoiceSheet) {
            VoiceBottomSheet(retailerName = retailer.name) { showVoiceSheet = false }
        }
    }
}

@Composable
fun LimeFactor(weight: String, reason: String, color: Color) {
    Row(verticalAlignment = Alignment.Top) {
        Box(
            modifier = Modifier
                .background(color.copy(alpha = 0.1f), RoundedCornerShape(4.dp))
                .border(1.dp, color.copy(alpha = 0.5f), RoundedCornerShape(4.dp))
                .padding(horizontal = 8.dp, vertical = 4.dp)
        ) {
            Text(weight, color = color, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.bodySmall)
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(reason, style = MaterialTheme.typography.bodyMedium, modifier = Modifier.weight(1f))
    }
}
