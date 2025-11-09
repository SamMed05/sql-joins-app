<script>
  import { onMount, onDestroy } from 'svelte'

  let { joinType = '0.0.0' } = $props()

  let containerEl = $state(null)
  let videoEl = $state(null)
  let isLoading = $state(false)
  let hasError = $state(false)
  let currentSrc = $state('')

  // Simple mapping: only map animations we actually have
  const animationMap = {
    '0.0.0': null, // default/none
    '0.1.0': 'inner_join', // Inner join
    '1.1.0': 'left_join', // Left join
    '0.1.1': 'right_join', // Right join
    '1.1.1': 'full_outer_join', // Full outer join
  }

  const getAnimationPath = (type) => {
    const animationName = animationMap[type]
    if (!animationName) return null
    return `/animations/${animationName}.mp4`
  }

  const loadAnimation = (type) => {
    const path = getAnimationPath(type)

    // Always stop and clear the current video first
    if (videoEl) {
      videoEl.pause()
      videoEl.src = ''
      videoEl.load()
    }

    // Default state: show empty container
    if (!path) {
      currentSrc = ''
      isLoading = false
      hasError = false
      return
    }

    // Begin loading the new source (cache-busted to avoid stale 404s)
    const cacheBusted = `${path}?v=${Date.now()}`
    currentSrc = cacheBusted
    isLoading = true
    hasError = false
    if (videoEl) {
      videoEl.src = cacheBusted
      videoEl.load()
    }
  }

  $effect(() => {
    loadAnimation(joinType)
  })

  onMount(() => {
    if (videoEl) {
      const onLoaded = () => {
        isLoading = false
        videoEl.play().catch(() => {})
      }
      const onError = () => {
        hasError = true
        isLoading = false
      }
      videoEl.addEventListener('loadeddata', onLoaded)
      videoEl.addEventListener('error', onError)

      // Cleanup listeners on destroy
      onDestroy(() => {
        videoEl.removeEventListener('loadeddata', onLoaded)
        videoEl.removeEventListener('error', onError)
      })
    }
  })

  onDestroy(() => {
    if (videoEl) {
      videoEl.pause()
      videoEl.src = ''
    }
  })
</script>

<style lang="postcss">
  .animation-container {
    width: 100%;
    max-width: 700px;
    margin: 0.75rem auto;
    padding: 0.5rem;
    background: #2a2a2a;
    border-radius: 8px;
    border: 1px solid #444;
    min-height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .animation-video {
    width: 100%;
    height: auto;
    border-radius: 4px;
    background: #1a1a1a;
  }

  .animation-video::-webkit-media-controls-panel {
    background: #00000000;
  }

  .placeholder {
    color: #888;
    text-align: center;
    padding: 2rem;
    font-size: 1rem;
  }

  .loading {
    color: #ff8e5a;
    font-size: 1rem;
  }

  .error {
    color: #ff6b6b;
    font-size: 0.9rem;
  }

  .hidden {
    display: none;
  }

  @media (max-width: 768px) {
    .animation-container {
      max-width: 100%;
      padding: 0.5rem;
      box-sizing: border-box;
    }
  }
</style>

<div class="animation-container" bind:this={containerEl}>
  {#if joinType === '0.0.0'}
    <div class="placeholder">Select a join type to see the animation</div>
  {:else if isLoading}
    <div class="loading">Loading animation...</div>
  {:else if hasError}
    <div class="error">Animation not available for this join type</div>
  {/if}

  <video
    bind:this={videoEl}
    class="animation-video"
    class:hidden={!currentSrc || isLoading || hasError}
    controls
    loop
    playsinline>
    <track kind="captions" />
  </video>
</div>
