package com.example.orderme.data

import com.example.orderme.BuildConfig
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.logging.HttpLoggingInterceptor
import java.io.IOException
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object Api {
    private const val DEFAULT_BASE =
        "http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000"
    val BASE_URL: String = BuildConfig.BASE_URL ?: DEFAULT_BASE

    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
    }

    private val client: OkHttpClient by lazy {
        val logging = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
        OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(20, TimeUnit.SECONDS)
            .writeTimeout(20, TimeUnit.SECONDS)
            .addInterceptor(logging)
            .build()
    }

    @Serializable
    private data class PlacesResponse(
        @SerialName("places") val places: List<Place> = emptyList()
    )

    @Throws(IOException::class)
    suspend fun fetchPlaces(): List<Place> = withContext(Dispatchers.IO) {
        val req = Request.Builder()
            .url("$BASE_URL/places")
            .get()
            .build()

        client.newCall(req).execute().use { resp ->
            val bodyStr = resp.body?.string().orEmpty()

            if (!resp.isSuccessful) {
                throw IOException("HTTP ${resp.code} ${resp.message} body=$bodyStr")
            }

            runCatching {
                json.decodeFromString(ListSerializer(Place.serializer()), bodyStr)
            }.getOrElse {
                json.decodeFromString(PlacesResponse.serializer(), bodyStr).places
            }
        }
    }

    fun fullImageUrl(path: String?): String? {
        if (path.isNullOrBlank()) return null
        return if (path.startsWith("http")) path else BASE_URL.trimEnd('/') + path
    }
}

@Serializable
data class Place(
    @SerialName("id") val id: Int? = null,
    @SerialName("name") val name: String? = null,
    @SerialName("address") val address: String? = null,
    @SerialName("imagePath") val imagePath: String? = null
)
