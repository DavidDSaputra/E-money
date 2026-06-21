# Spesifikasi Deeplink Pembayaran Dompet Kampus Global

Dokumen ini mencatat format deeplink pembayaran merchant yang diterima aplikasi
Dompet Kampus Global.

## Format URL

Custom scheme:

```text
dompetkampus://pay?merchant_id=MCH001&merchant_name=Kantin%20Kampus&amount=25000&description=Makan%20Siang&reference=INV-001&callback=pasarmalam%3A%2F%2Fpayment-callback
```

HTTPS App Link opsional:

```text
https://dompetkampus.app/pay?merchant_id=MCH001&merchant_name=Kantin%20Kampus&amount=25000
```

## Parameter

| Parameter | Wajib | Keterangan |
| --- | --- | --- |
| `merchant_id` | Ya | ID merchant, tidak boleh kosong. |
| `merchant_name` | Ya | Nama merchant yang ditampilkan ke user. |
| `amount` | Ya | Nominal Rupiah, angka lebih dari 0. |
| `description` | Tidak | Keterangan pembayaran. Default: `Pembayaran ke <merchant_name>`. |
| `reference` | Tidak | Nomor invoice/referensi merchant. |
| `callback` | Tidak | Deeplink callback merchant untuk status pembayaran. |

## Alur

1. Merchant membuka `dompetkampus://pay?...`.
2. `DeeplinkService` memvalidasi parameter dan membuka route `/pay`.
3. `PaymentDeeplinkPage` menampilkan ringkasan pembayaran.
4. User menekan bayar, lalu masuk ke `/pin`.
5. `PinPage` meminta PIN, lalu OTP/TOTP sesuai metode 2FA tersimpan.
6. App memanggil `POST /v1/payment/transfer`.
7. Jika sukses, aplikasi membuka `/success` dan mengirim callback best-effort jika `callback` tersedia.

## Mapping 2FA

| `k2faMethod` | UI | `otp_type` backend |
| --- | --- | --- |
| `totp` | Kode Authenticator | `totp` |
| `smtp` | OTP email + resend timer | `email` |
| `notif` | OTP notifikasi + resend timer | `firebase` |

## Testing Android

PowerShell:

```powershell
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" shell "am start -a android.intent.action.VIEW -d 'dompetkampus://pay?merchant_id=MCH001&merchant_name=Kantin%20Kampus&amount=25000&description=Makan%20Siang&reference=INV-001'"
```

Dengan callback:

```powershell
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" shell "am start -a android.intent.action.VIEW -d 'dompetkampus://pay?merchant_id=MCH001&merchant_name=Kantin%20Kampus&amount=25000&reference=INV-001&callback=pasarmalam%3A%2F%2Fpayment-callback'"
```
