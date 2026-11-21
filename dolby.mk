#
# Copyright (C) 2022 FlamingoOS Project
# Copyright (C) 2023-2024 The LineageOS Project
# Copyright (C) 2024-2025 Lunaris AOSP
# Copyright (C) 2024-2026 Gamehac_RA (Motorola Dolby Port for Sapphire)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Dolby repository path (default: hardware/dolby or hardware/motorola/dolby)
DOLBY_PATH ?= hardware/dolby

# Soong Namespace
PRODUCT_SOONG_NAMESPACES += \
    $(DOLBY_PATH)

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DOLBY_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DOLBY_PATH)/sepolicy/private

# VINTF Manifests & Compatibility Matrix
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DOLBY_PATH)/configs/vintf/dolby_framework_matrix.xml
DEVICE_MANIFEST_FILE += \
    $(DOLBY_PATH)/configs/vintf/vendor.dolby.hardware.dms@2.0-service.xml \
    $(DOLBY_PATH)/configs/vintf/vendor.dolby.media.c2@1.0-service.xml

# Codec2 System Dependencies
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor \
    libcodec2_hidl@1.2.vendor \
    libstagefright_foundation-v33 \
    libcodec2_soft_common.vendor

# Init Scripts & Early Boot
PRODUCT_PACKAGES += \
    init.dolby.rc

# Configs & Tuning Profiles (SM6225 10-Profile DAX + Moto SST)
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/dax/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml \
    $(DOLBY_PATH)/configs/aualgo/aualgo_sst.conf:$(TARGET_COPY_OUT_VENDOR)/etc/aualgo/aualgo_sst.conf \
    $(DOLBY_PATH)/configs/media/media_codecs_dolby_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby_audio.xml \
    $(DOLBY_PATH)/proprietary/vendor/etc/init/vendor.dolby.hardware.dms@2.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.dolby.hardware.dms@2.0-service.rc \
    $(DOLBY_PATH)/proprietary/vendor/etc/init/vendor.dolby.media.c2@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.dolby.media.c2@1.0-service.rc

# System Permissions, Sysconfigs & Default Permissions
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.motorola.android.providers.settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.motorola.android.providers.settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto-core_services.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-core_services.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto-settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto-checkin.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-checkin.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.motosignature.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.motosignature.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.frameworks.core.addon.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.frameworks.core.addon.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.software.dolby.motodolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.software.dolby.motodolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.software.sstservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.software.sstservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.android.providers.settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.android.providers.settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.motosignature.app.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.motosignature.app.xml \
    $(DOLBY_PATH)/proprietary/system/etc/default-permissions/default-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/default-permissions/default-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/enable-disable-packages/enable-disable-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/enable-disable-packages/enable-disable-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/enable-disable-packages/enable-disable-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/enable-disable-packages/enable-disable-com.motorola.dolby.dolbyui.xml

# System Applications & Moto Framework
PRODUCT_PACKAGES += \
    MotoDolbyDax3 \
    daxService \
    MotorolaSettingsProvider \
    MotoSignatureApp \
    moto \
    moto-core_services \
    moto-settings \
    moto-checkin \
    com.motorola.motosignature \
    com.motorola.frameworks.core.addon

# Vendor HAL & Libraries
PRODUCT_PACKAGES += \
    vendor.dolby.hardware.dms@2.0-impl \
    vendor.dolby.hardware.dms@2.0 \
    vendor.dolby.hardware.dms@2.0-service \
    vendor.dolby.media.c2@1.0-service \
    libcodec2_soft_ac4dec \
    libcodec2_soft_ddpdec \
    libcodec2_soft_dolby \
    libcodec2_store_dolby \
    libdapparamstorage \
    libdeccfg \
    libdlbdsservice \
    libdlbpreg \
    libspatializerparamstorage \
    liboem_specific \
    libswspatializer_ext \
    libstagefrightdolby \
    libstagefright_fdtn_dolby \
    libaualgo_foundation \
    libaualgo_sst_component

# Audio Effects & Soundfx
PRODUCT_PACKAGES += \
    libmsstwrapper \
    libdlbvol \
    libswgamedap \
    libswspatializer \
    libswvqe

# DAP Implementation Selection (Software DAP vs Hardware DAP)
ifeq ($(USE_HWDAP),true)
PRODUCT_PACKAGES += \
    libhwdap
else
PRODUCT_PACKAGES += \
    libswdap
endif

# Motorola Dolby Atmos & Qualcomm SM6225 DSP Properties
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.audio_fx.current=dolby \
    ro.vendor.dolby.dax.version=DAX3_3.8.5.20_r1 \
    ro.vendor.audio.moto_sst_supported=true \
    ro.audio.ignore_effects=false \
    ro.dolby.mod_uuid=false \
    ro.dolby.music_stream=false \
    ro.spatial.music_stream=false \
    ro.audio.spatializer_enabled=true \
    ro.vendor.audio.dolby.dax.support=true \
    ro.vendor.audio.dolby.surround.enable=true \
    ro.audio.spatializer_transaural_enabled_default=false \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false \
    audio.deep_buffer.media=false \
    media.stagefright.audio.deep=false \
    audio.offload.disable=1 \
    vendor.audio.offload.track.enable=false \
    vendor.audio.offload.multiple.enabled=false
