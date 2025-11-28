package com.example.orderme

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.orderme.ui.LoginScreen
import com.example.orderme.ui.PlacesScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface {
                    AppNavHost()
                }
            }
        }
    }
}

@Composable
fun AppNavHost() {
    val nav = rememberNavController()
    NavHost(navController = nav, startDestination = "login") {
        composable("login") {
            LoginScreen(onLoginLater = {
                // Keep login on the back stack so 'Back' from places returns to login
                nav.navigate("places")
            })
        }
        composable("places") {
            PlacesScreen(onBack = { nav.popBackStack() })
        }
    }
}