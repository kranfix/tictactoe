package com.example.tic_tac_toe_jetpack_compose

import android.content.res.Configuration
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.Wallpapers
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import com.example.tic_tac_toe_jetpack_compose.ui.theme.AppColors
import com.example.tic_tac_toe_jetpack_compose.ui.theme.TictactoejetpackcomposeTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        setContent {
            TictactoejetpackcomposeTheme {
                Greeting()

            }
        }
    }
}

@Composable
fun Greeting() {
    Scaffold(
        containerColor = AppColors.background,
        contentWindowInsets = WindowInsets(0.dp, 0.dp, 0.dp, 0.dp)

        ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding),

            ) {

          Spacer(modifier = Modifier)
            LazyVerticalGrid(columns = GridCells.Adaptive(minSize = 128.dp)) {
               
            }
        }
    }
}

@Preview(
    showBackground = true,
    device = "spec:id=reference_phone,shape=Normal,width=411,height=891,unit=dp,dpi=420",
    uiMode = Configuration.UI_MODE_NIGHT_NO or Configuration.UI_MODE_TYPE_NORMAL,
    wallpaper = Wallpapers.NONE, showSystemUi = true
)
@Composable
fun GreetingPreview() {
    TictactoejetpackcomposeTheme {
        Greeting()
    }
}