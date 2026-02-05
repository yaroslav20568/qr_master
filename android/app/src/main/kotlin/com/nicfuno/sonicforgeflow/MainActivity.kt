package com.nicfuno.sonicforgeflow

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.ContactsContract
import android.provider.MediaStore
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "qr_master/image_saver"
    private val QR_ACTIONS_CHANNEL = "qr_master/actions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveImageToGallery") {
                val imagePath = call.argument<String>("imagePath")
                val albumName = call.argument<String>("albumName") ?: "QR Master"
                
                if (imagePath != null) {
                    val saved = saveImageToGallery(imagePath, albumName)
                    result.success(saved)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, QR_ACTIONS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "addContact" -> {
                    val vcardData = call.argument<String>("vcardData")
                    if (vcardData != null) {
                        val success = addContact(vcardData)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "vCard data is null", null)
                    }
                }
                "connectToWifi" -> {
                    val ssid = call.argument<String>("ssid")
                    val password = call.argument<String>("password")
                    val type = call.argument<String>("type") ?: "WPA"
                    if (ssid != null) {
                        val success = connectToWifi(ssid, password, type)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "SSID is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun saveImageToGallery(imagePath: String, albumName: String): Boolean {
        return try {
            val file = File(imagePath)
            if (!file.exists()) {
                return false
            }

            val bitmap = BitmapFactory.decodeFile(file.absolutePath)
            if (bitmap == null) {
                return false
            }

            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/$albumName")
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                } else {
                    val picturesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                    val albumDir = File(picturesDir, albumName)
                    if (!albumDir.exists()) {
                        albumDir.mkdirs()
                    }
                    val savedFile = File(albumDir, file.name)
                    put(MediaStore.MediaColumns.DATA, savedFile.absolutePath)
                }
            }

            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
            
            if (uri != null) {
                contentResolver.openOutputStream(uri)?.use { outputStream ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                }
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    contentValues.clear()
                    contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                    contentResolver.update(uri, contentValues, null, null)
                }
                
                true
            } else {
                false
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun addContact(vcardData: String): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_INSERT).apply {
                type = ContactsContract.Contacts.CONTENT_TYPE
                putExtra(ContactsContract.Intents.Insert.NAME, extractContactName(vcardData))
                putExtra(ContactsContract.Intents.Insert.PHONE, extractContactPhone(vcardData))
                putExtra(ContactsContract.Intents.Insert.EMAIL, extractContactEmail(vcardData))
            }
            startActivity(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun extractContactName(vcardData: String): String {
        val lines = vcardData.split("\n")
        for (line in lines) {
            if (line.startsWith("FN:")) {
                return line.substring(3).trim()
            } else if (line.startsWith("N:")) {
                val nameParts = line.substring(2).split(";")
                val name = nameParts.filter { it.isNotEmpty() }.joinToString(" ")
                if (name.isNotEmpty()) {
                    return name.trim()
                }
            }
        }
        return ""
    }

    private fun extractContactPhone(vcardData: String): String {
        val lines = vcardData.split("\n")
        for (line in lines) {
            if (line.startsWith("TEL:")) {
                return line.substring(4).trim()
            }
        }
        return ""
    }

    private fun extractContactEmail(vcardData: String): String {
        val lines = vcardData.split("\n")
        for (line in lines) {
            if (line.startsWith("EMAIL:")) {
                return line.substring(6).trim()
            }
        }
        return ""
    }

    private fun connectToWifi(ssid: String, password: String?, type: String): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val intent = Intent(Settings.Panel.ACTION_INTERNET_CONNECTIVITY)
                startActivity(intent)
            } else {
                val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
                startActivity(intent)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
