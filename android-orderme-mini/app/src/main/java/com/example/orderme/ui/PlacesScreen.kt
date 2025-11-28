package com.example.orderme.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.example.orderme.data.Api
import com.example.orderme.data.Place
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

@Composable
fun PlacesScreen(onBack: () -> Unit, vm: PlacesViewModel = viewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(Unit) {
        vm.load()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Restaurants") },
                navigationIcon = {
                    TextButton(onClick = onBack) { Text("Back") }
                }
            )
        }
    ) { padding ->
        when {
            state.loading -> {
                Box(Modifier.fillMaxSize().padding(padding)) {
                    CircularProgressIndicator(Modifier.align(Alignment.Center))
                }
            }
            state.error != null -> {
                Box(Modifier.fillMaxSize().padding(padding)) {
                    Text(text = state.error ?: "", modifier = Modifier.align(Alignment.Center))
                }
            }
            else -> {
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding),
                    contentPadding = PaddingValues(12.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    items(state.data) { place ->
                        PlaceRow(place)
                    }
                }
            }
        }
    }
}

@Composable
private fun PlaceRow(place: Place) {
    Card(
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(modifier = Modifier.padding(12.dp)) {
            val imgUrl = Api.fullImageUrl(place.imagePath)
            AsyncImage(
                model = imgUrl,
                contentDescription = place.name,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .size(84.dp)
                    .clip(MaterialTheme.shapes.medium)
            )
            Spacer(Modifier.width(12.dp))
            Column(Modifier.weight(1f)) {
                Text(place.name ?: "", style = MaterialTheme.typography.titleMedium)
                Text(place.address ?: "", style = MaterialTheme.typography.bodyMedium)
            }
        }
    }
}

class PlacesViewModel : ViewModel() {
    data class UiState(
        val loading: Boolean = false,
        val data: List<Place> = emptyList(),
        val error: String? = null
    )
    private val _state = MutableStateFlow(UiState(loading = true))
    val state: StateFlow<UiState> = _state

    fun load() {
        if (!_state.value.loading && _state.value.data.isNotEmpty()) return
        _state.value = UiState(loading = true)
        viewModelScope.launch {
            try {
                val places = Api.fetchPlaces()
                _state.value = UiState(loading = false, data = places, error = null)
            } catch (t: Throwable) {
                _state.value = UiState(loading = false, data = emptyList(), error = t.message ?: "Error")
            }
        }
    }
}