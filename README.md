# Tutorial 7 - 3D

**Nama:** Alvin Rheinaldy  
**NPM:** 2306275866  

## Fitur & Mekanik yang Diimplementasikan

Pada tutorial ini, saya memilih untuk mengimplementasikan **kedua** mekanik tambahan (Sprinting & Crouching serta Pick up & Inventory) ditambah beberapa *polish* ekstra:

### 1. Advanced Player Movement (Sprint & Crouch)
* **Sprinting:** Pemain dapat berlari lebih cepat dengan menekan tombol `Shift`. Kecepatan akan diinterpolasi (lerp) agar transisi pergerakan terasa mulus.
* **Crouching:** Pemain dapat berjongkok menggunakan tombol `Ctrl`. 
  * Kamera akan merunduk secara halus (menggunakan interpolasi).
  * *CollisionShape3D* (hitbox) pemain akan mengecil secara dinamis dan posisinya disesuaikan agar pemain dapat melewati celah sempit tanpa membuat kaki karakter melayang atau tersangkut (*anti-floating fix*).

### 2. Item Pick-up & Inventory System
* Pemain dapat berinteraksi dengan objek di dunia 3D (seperti `ObjLamp`) menggunakan `RayCast3D`.
* Objek yang berada dalam grup `"item"` dapat diambil dengan menekan tombol `E`.
* Item yang diambil akan disimpan ke dalam struktur data `Array` dan dihapus dari *scene* utama.

### 3. User Interface (HUD)
* **Crosshair:** Crosshair.
* **Item Counter:** Teks UI statis di pojok kiri atas layar yang akan terus diperbarui secara *real-time* seiring bertambahnya item di dalam inventory.
