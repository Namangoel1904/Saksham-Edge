package com.example.beingnotified

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.beingnotified.ui.screens.HomeScreen
import com.example.beingnotified.ui.screens.MainViewModel
import com.example.beingnotified.ui.screens.RetailerDetailScreen
import com.example.beingnotified.ui.screens.RouteMapScreen
import com.example.beingnotified.ui.theme.BeingNotifiedTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            BeingNotifiedTheme {
                val navController = rememberNavController()
                val viewModel: MainViewModel = viewModel()

                NavHost(navController = navController, startDestination = "home") {
                    composable("home") {
                        HomeScreen(
                            viewModel = viewModel,
                            onNavigateToDetail = { id -> navController.navigate("detail/$id") },
                            onNavigateToMap = { navController.navigate("map") }
                        )
                    }
                    composable("map") {
                        RouteMapScreen(
                            viewModel = viewModel,
                            onNavigateBack = { navController.popBackStack() }
                        )
                    }
                    composable("detail/{retailerId}") { backStackEntry ->
                        val id = backStackEntry.arguments?.getString("retailerId") ?: ""
                        RetailerDetailScreen(
                            retailerId = id,
                            viewModel = viewModel,
                            onNavigateBack = { navController.popBackStack() }
                        )
                    }
                }
            }
        }
    }
}