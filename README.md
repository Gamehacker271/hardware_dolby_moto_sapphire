# Motorola Dolby Atmos (DAX3) & Spatial Sound (Moto SST)
### AOSP Hardware Tree for Redmi Note 13 4G / 4G NFC (`sapphire` / `sapphiren`)
#### Platform: Qualcomm Snapdragon 685 (SM6225) | Android 14 / 15

[![Platform](https://img.shields.io/badge/SoC-Qualcomm%20Snapdragon%20685%20(SM6225)-blue.svg)](#)
[![Android](https://img.shields.io/badge/Android-14%20%2F%2015-green.svg)](#)
[![Target](https://img.shields.io/badge/Target-AOSP%20%2F%20LineageOS%20%2F%20Custom%20ROMs-purple.svg)](#)
[![Status](https://img.shields.io/badge/Status-Fully%20Functional-brightgreen.svg)](#)

A complete, production-grade AOSP hardware tree component for compiling **Motorola Dolby Atmos (DAX3) and Motorola Spatial Sound (Moto SST)** natively into custom ROMs (LineageOS, PixelOS, crDroid, EvolutionX, Paranoid Android, etc.) for the **Xiaomi Redmi Note 13 4G / 4G NFC** (`sapphire` / `sapphiren`).

Based on and adapted from the [ximi685-ad-development/hardware_dolby_new](https://github.com/ximi685-ad-development/hardware_dolby_new) AOSP architecture, featuring the official Motorola Dolby UI (`MotoDolbyDax3`) and automatic build-time audio effects configuration.

---

## 📁 Repository Structure

```
hardware/dolby/
├── Android.bp                                 # Soong build declarations for libraries, services & APKs
├── dolby.mk                                   # Product makefile to inherit in device.mk
├── README.md                                  # Integration & documentation guide
├── configs/
│   ├── audio/
│   │   └── audio_effects.xml                  # Pre-configured audio effects XML for Sapphire SM6225
│   ├── aualgo/
│   │   └── aualgo_sst.conf                    # Motorola Smart Sound DSP configuration
│   ├── dax/
│   │   └── dax-default.xml                    # SM6225 10-Profile DAX tuning (Prevents index 9 crash)
│   ├── media/
│   │   └── media_codecs_dolby_audio.xml       # Codec2 AC-3, E-AC-3, JOC, AC-4 declarations
│   └── vintf/
│       ├── dolby_framework_matrix.xml         # Framework compatibility matrix
│       ├── vendor.dolby.hardware.dms@2.0-service.xml
│       └── vendor.dolby.media.c2@1.0-service.xml
├── proprietary/
│   ├── system/                                # Official Motorola UI, DaxService & Framework JARs
│   │   ├── app/MotoSignatureApp/
│   │   ├── priv-app/
│   │   │   ├── daxService/
│   │   │   ├── MotoDolbyDax3/
│   │   │   └── MotorolaSettingsProvider/
│   │   ├── framework/                         # moto.jar, moto-core_services.jar, etc.
│   │   └── etc/                               # permissions, sysconfig, default-permissions
│   └── vendor/                                # Proprietary 64-bit and 32-bit vendor libraries
│       ├── bin/hw/                            # dms@2.0-service & media.c2@1.0-service
│       ├── etc/init/                          # Init rc scripts
│       ├── lib/                               # 32-bit codecs & soundfx (multilib)
│       └── lib64/                             # 64-bit codecs, soundfx & SST foundations
├── rootdir/
│   └── etc/
│       ├── Android.bp
│       └── init.dolby.rc                      # Early runtime directory initialization
└── sepolicy/
    ├── private/
    │   └── priv_app.te                        # Priv-app binder IPC permissions
    └── vendor/
        ├── attributes
        ├── audioserver.te
        ├── file_contexts
        ├── file.te
        ├── hal_audio_default.te
        ├── hal_dms_default.te
        ├── hal_dms.te
        ├── hwservice_contexts
        ├── hwservice.te
        ├── mediacodec.te
        └── priv_app.te
```

---

## 🚀 Getting Started (AOSP ROM Integration)

### 1. Clone into ROM Source Tree

Clone this repository into `hardware/dolby` inside your ROM source tree:

```bash
git clone https://github.com/Gamehacker271/hardware_dolby_moto_sapphire.git hardware/dolby
```

*(Note: If you place it under a different path such as `hardware/motorola/dolby`, specify `DOLBY_PATH := hardware/motorola/dolby` before inheriting `dolby.mk`).*

---

### 2. Inherit Product Configuration in `device.mk`

Open your device's product makefile (e.g., `device/xiaomi/sapphire/device.mk`) and add:

```makefile
# Motorola Dolby Atmos (DAX3) & Spatial Sound (Moto SST)
$(call inherit-product, hardware/dolby/dolby.mk)
```

If your kernel / audio HAL utilizes hardware DAP offload instead of software DAP, add:

```makefile
USE_HWDAP := true
$(call inherit-product, hardware/dolby/dolby.mk)
```

---

### 3. VINTF Configuration in `BoardConfig.mk`

Ensure manifest and compatibility matrix fragments are appended using `+=` in `BoardConfig.mk`:

```makefile
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/dolby/configs/vintf/dolby_framework_matrix.xml

DEVICE_MANIFEST_FILE += \
    hardware/dolby/configs/vintf/vendor.dolby.hardware.dms@2.0-service.xml \
    hardware/dolby/configs/vintf/vendor.dolby.media.c2@1.0-service.xml
```

---

### 4. Automatic Audio Effects Configuration (`audio_effects.xml`)

> ⚡ **Zero Manual Editing Needed:**  
> `dolby.mk` automatically deploys the pre-configured, tested `audio_effects.xml` directly to `$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml` during the compilation of your ROM.

If your device tree (`device/xiaomi/sapphire`) already has a line in `device.mk` copying an `audio_effects.xml`, simply **comment out or remove** that line:

```makefile
# Remove or comment out any old device audio_effects.xml copy line:
# PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml
```

#### Why is this configuration critical for Snapdragon 685 (SM6225)?
1. **Exclusive AudioFlinger Control (`Ctrl=yes`):**  
   `<apply effect="dap_mod"/>` is intentionally **omitted** from `<postprocess>`. This prevents `audioserver` from stealing `Ctrl=yes` on Session 0 at boot, guaranteeing that `daxservice` gets exclusive control and real-time equalizer manipulation works properly.
2. **Qualcomm HAL Stream Compatibility:**  
   Postprocess only binds to valid Qualcomm SM6225 streams (`music`, `ring`, `alarm`, `notification`). Modern generic AOSP stream tags (`patch`, `accessibility`, `call_assistant`) are excluded to prevent `EffectsConfig` parser crashes.
3. **Motorola Spatial Sound (Moto SST):**  
   `moto_sst` (UUID `01325f27-2882-44f7-bdec-e7ce4ea3a581`) is bound to all output streams alongside Dolby Volume Listeners (`dvl_*`), enabling seamless spatializer switching.

---

### 5. Media Codecs

Include the Dolby Codec2 XML in your vendor `media_codecs.xml`:

```xml
<Include href="media_codecs_dolby_audio.xml" />
```

---

## 🔬 Key Breakthroughs Built into this Tree

| Issue / Bug | Root Cause | Solution in this Tree |
| :--- | :--- | :--- |
| **Profile Crash & "Loading" Hang** | Xiaomi stock `dax-default.xml` only defines 9 profiles (0-8). Moto DAX3 queries 10 profiles (profile 8 = Game, profile 9 = Voice), crashing with `Invalid profile index9`. | Bundled Motorola 10-profile DSP tuning `dax-default.xml` (121 KB). |
| **Spatial Audio Toggle Inoperative** | `libmsstwrapper.so` requires `libaualgo_foundation.so`. Due to VNDK Treble namespace isolation, vendor libraries cannot load dependencies from `/system`. | `libaualgo_foundation.so` and `libaualgo_sst_component.so` placed directly in `/vendor/lib64/` and `/vendor/lib/`. |
| **AudioFlinger Control Stealing** | `dap_mod` in `<postprocess>` causes `audioserver` to steal `Ctrl=yes` on Session 0. | `dap_mod` left exclusively to `daxservice` as sole client (`Ctrl=yes`). |
| **SELinux IPC Denials** | `priv_app` denied access to `hal_dms_hwservice` and Binder transfers. | Integrated `hal_client_domain(priv_app, hal_dms)` and bidirectional Binder IPC rules. |

---

## 🤝 Credits & Acknowledgements

* **[ximi685-ad-development](https://github.com/ximi685-ad-development)** — Reference AOSP hardware tree architecture ([hardware_dolby_new](https://github.com/ximi685-ad-development/hardware_dolby_new)).
* **[Rei Ryuki (reiryuki)](https://github.com/reiryuki)** — Upstream Moto Core & Dolby Atmos modules:
  * [Moto-Core-Magisk-Module](https://github.com/reiryuki/Moto-Core-Magisk-Module)
  * [Dolby-Atmos-Spatial-Sound-Moto-Edge-30-Ultra-Magisk-Module](https://github.com/reiryuki/Dolby-Atmos-Spatial-Sound-Moto-Edge-30-Ultra-Magisk-Module)
* **Dolby Laboratories** & **Motorola Mobility LLC** (Proprietary audio algorithms, DAX3 HIDL HAL, and DSP tuning).
* **Gamehac_RA** — Porting, audio pipeline debugging, SELinux policy engineering, and hardware validation on Redmi Note 13 4G (`sapphire`).
* **Google DeepMind Antigravity** — AudioFlinger Session 0 trace analysis, DSP routing diagnosis, and automated tree generation.
