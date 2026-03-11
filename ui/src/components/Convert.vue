<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'

const getBase64Image = (src: string, callback: (dataUrl: string | null) => void) => {
  const img = new Image()
  img.crossOrigin = 'Anonymous'

  img.onload = () => {
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')!

    canvas.height = img.naturalHeight
    canvas.width = img.naturalWidth

    ctx.clearRect(0, 0, canvas.width, canvas.height)
    ctx.drawImage(img, 0, 0)

    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
    const data = imageData.data

    for (let i = 0; i < data.length; i += 4) {
      if (data[i] === 0 && data[i + 1] === 0 && data[i + 2] === 0) {
        data[i + 3] = 0
      }
    }

    ctx.putImageData(imageData, 0, 0)
    const dataURL = canvas.toDataURL('image/png')

    canvas.remove()
    img.remove()

    callback(dataURL)
  }

  img.onerror = () => {
    console.error('Error loading image:', src)
    callback(null)
  }

  img.src = src
}

const convertImage = (pMugShotTxd: string, id: number) => {
  let tempUrl = `https://nui-img/${pMugShotTxd}/${pMugShotTxd}?t=${String(Math.round(new Date().getTime() / 1000))}`
  if (pMugShotTxd === 'none') {
    tempUrl = 'https://upload.peakrp.pl/static/msk_logo.png'
  }

  getBase64Image(tempUrl, (dataUrl) => {
    if (dataUrl) {
      fetch('https://msk_bridge/Convert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url: dataUrl, id: id }),
      }).catch((error) => {
        console.error('Error sending data:', error)
      })
    }
  })
}

const handleMessage = (event: MessageEvent) => {
  if (event.data?.action === 'convert' && event.data?.pMugShotTxd !== undefined) {
    convertImage(event.data.pMugShotTxd, event.data.id)
  }
}

onMounted(() => {
  window.addEventListener('message', handleMessage)
})

onUnmounted(() => {
  window.removeEventListener('message', handleMessage)
})
</script>

<template></template>