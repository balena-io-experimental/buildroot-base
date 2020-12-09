variable "IMAGE_REPO" {
    default = "docker.io/klutchell"
}

variable "BR_VERSION" {
    default = "2020.11"
}

variable "IMAGE_TAG" {
    default = "2020.11"
}

group "default" {
    targets = [
        "base",
        "rootfs-amd64",
        "rootfs-aarch64",
        "rootfs-armv7hf",
        "rootfs-armv6hf",
    ]
}

target "base" {
    target = "base"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["${IMAGE_REPO}/buildroot-base:${IMAGE_TAG}"]
    args = {
        "BR_VERSION": "${BR_VERSION}"
    }
}

target "rootfs-amd64" {
    target = "rootfs"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["${IMAGE_REPO}/buildroot-rootfs-amd64:${IMAGE_TAG}"]
    args = {
        "BR_VERSION": "${BR_VERSION}"
        "ROOTFS_ARCH": "amd64"
    }
}

target "rootfs-aarch64" {
    target = "rootfs"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        "${IMAGE_REPO}/buildroot-rootfs-arm64:${IMAGE_TAG}",
        "${IMAGE_REPO}/buildroot-rootfs-aarch64:${IMAGE_TAG}"
    ]
    args = {
        "BR_VERSION": "${BR_VERSION}"
        "ROOTFS_ARCH": "aarch64"
    }
}

target "rootfs-armv7hf" {
    target = "rootfs"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        "${IMAGE_REPO}/buildroot-rootfs-arm32v7:${IMAGE_TAG}",
        "${IMAGE_REPO}/buildroot-rootfs-armv7hf:${IMAGE_TAG}"
    ]
    args = {
        "BR_VERSION": "${BR_VERSION}"
        "ROOTFS_ARCH": "armv7hf"
    }
}

target "rootfs-armv6hf" {
    target = "rootfs"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        "${IMAGE_REPO}/buildroot-rootfs-arm32v6:${IMAGE_TAG}",
        "${IMAGE_REPO}/buildroot-rootfs-armv6hf:${IMAGE_TAG}",
        "${IMAGE_REPO}/buildroot-rootfs-rpi:${IMAGE_TAG}"
    ]
    args = {
        "BR_VERSION": "${BR_VERSION}"
        "ROOTFS_ARCH": "armv6hf"
    }
}

target "rootfs-rpi" {
    target = "rootfs"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["${IMAGE_REPO}/buildroot-rootfs-rpi:${IMAGE_TAG}"]
    args = {
        "BR_VERSION": "${BR_VERSION}"
        "ROOTFS_ARCH": "rpi"
    }
}
