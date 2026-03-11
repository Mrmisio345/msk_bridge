<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'

const saveToClipboard = async (text: string) => {
  try {
    const node = document.createElement('textarea')
    const selection = document.getSelection()

    node.textContent = text
    document.body.appendChild(node)

    selection?.removeAllRanges()
    node.select()
    document.execCommand('copy')

    selection?.removeAllRanges()
    document.body.removeChild(node)
  } catch (error) {
    console.error('Error copying to clipboard:', error)
  }
}

const handleMessage = (event: MessageEvent) => {
  if (event.data?.action === 'saveClipboard' && event.data?.text) {
    saveToClipboard(event.data.text)
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