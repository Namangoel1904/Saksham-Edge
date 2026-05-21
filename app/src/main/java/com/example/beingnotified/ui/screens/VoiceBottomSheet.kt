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

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VoiceBottomSheet(retailerName: String, onDismiss: () -> Unit) {
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
            Text(
                text = "\"Why am I visiting $retailerName?\"",
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
                Text(
                    text = "System: Satellite NDVI shows crop stress in a 5km radius, and store inventory for Voliam Targo is critically low.",
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.SemiBold
                )
            }
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}
