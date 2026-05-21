package com.example.beingnotified.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Mic

import com.example.beingnotified.data.RetailerEntity

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VoiceBottomSheet(retailer: RetailerEntity?, onDismiss: () -> Unit) {
    ModalBottomSheet(onDismissRequest = onDismiss) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(Icons.Default.Mic, contentDescription = null, tint = MaterialTheme.colorScheme.secondary, modifier = Modifier.size(48.dp))
            Spacer(modifier = Modifier.height(16.dp))
            Text("Listening... (Bhashini API Mock)", fontStyle = FontStyle.Italic, color = Color.Gray)
            Spacer(modifier = Modifier.height(24.dp))
            
            val name = retailer?.name ?: "General Area"
            Text(
                text = "\"Why am I visiting $name?\"",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(24.dp))
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color(0xFFE3F2FD), RoundedCornerShape(8.dp))
                    .border(1.dp, Color(0xFFBBDEFB), RoundedCornerShape(8.dp))
                    .padding(16.dp)
            ) {
                val systemText = if (retailer != null) {
                    val baseAction = retailer.nextBestAction.takeIf { it.isNotBlank() } ?: "Conduct Routine Inventory Check"
                    "System: $name has a critical priority score of ${retailer.priorityScore}. Their inventory is currently ${retailer.inventoryLevel}. My recommendation is: $baseAction."
                } else {
                    "System: No specific retailer selected. I recommend checking the map for high priority areas."
                }
                
                Text(
                    text = systemText,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.SemiBold
                )
            }
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}
