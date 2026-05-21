package com.example.beingnotified.ui.screens

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.beingnotified.data.AppDatabase
import com.example.beingnotified.data.RetailerEntity
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainViewModel(application: Application) : AndroidViewModel(application) {
    private val dao = AppDatabase.getDatabase(application).retailerDao()

    private val _retailers = MutableStateFlow<List<RetailerEntity>>(emptyList())
    val retailers: StateFlow<List<RetailerEntity>> = _retailers

    fun loadRetailers() {
        viewModelScope.launch(kotlinx.coroutines.Dispatchers.IO) {
            _retailers.value = dao.getAssignedRetailers()
        }
    }

    fun boostPriority(id: String, amount: Int) {
        viewModelScope.launch(kotlinx.coroutines.Dispatchers.IO) {
            dao.boostPriority(id, amount)
            val updated = dao.getAssignedRetailers()
            _retailers.value = updated
        }
    }
}
