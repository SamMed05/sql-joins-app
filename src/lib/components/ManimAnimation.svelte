<script>
  import { onMount, onDestroy } from 'svelte'
  import { base } from '$app/paths'

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
    return `${base}/animations/${animationName}.webm`
  }

  const getGitHubCodeUrl = (type) => {
    const animationName = animationMap[type]
    if (!animationName) return null
    return `https://github.com/SamMed05/sql-joins-app/blob/master/manim_scripts/${animationName}.py`
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

    // Load the video without cache busting to allow proper caching
    currentSrc = path
    isLoading = true
    hasError = false
    if (videoEl) {
      videoEl.src = path
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
        // Try to play, but don't let it break if autoplay is blocked
        // In iframes, muted videos have a better chance of autoplaying
        videoEl.play().catch((error) => {
          // Autoplay was prevented, user will need to click play
          console.log('Autoplay prevented - user interaction required', error)
        })
      }
      const onError = (e) => {
        console.error('Video loading error:', e, 'Source:', videoEl?.src)
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
    max-width: 650px;
    margin: 0.75rem auto;
    padding: 0.5rem;
    background: #2a2a2a;
    border-radius: 8px;
    border: 1px solid #444;
    min-height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
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

  .code-link-button {
    position: absolute;
    top: 1rem;
    right: 1rem;
    padding: 0.5rem 0.75rem;
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(4px);
    border: 1px solid #555;
    border-radius: 6px;
    color: #ff8e5a;
    text-decoration: none;
    font-size: 0.85rem;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 0.4rem;
    transition: all 0.2s ease;
    z-index: 10;
  }

  .code-link-button:hover {
    background: rgba(26, 26, 26, 0.95);
    border-color: #ff8e5a;
    transform: translateY(-1px);
  }

  .code-link-button svg {
    width: 16px;
    height: 16px;
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

    .code-link-button {
      top: 0.5rem;
      right: 0.5rem;
      padding: 0.4rem 0.6rem;
      font-size: 0.75rem;
    }

    .code-link-button svg {
      width: 14px;
      height: 14px;
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

  {#if getGitHubCodeUrl(joinType)}
    <a
      href={getGitHubCodeUrl(joinType)}
      target="_blank"
      rel="noopener noreferrer"
      class="code-link-button"
      title="View Manim source code on GitHub">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor">
        <path
          d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38
          0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01
          1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95
          0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0
          1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0
          3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013
          8.013 0 0016 8c0-4.42-3.58-8-8-8z" />
      </svg>
      <span>View Code</span>
    </a>
  {/if}

  <video
    bind:this={videoEl}
    class="animation-video"
    class:hidden={!currentSrc || isLoading || hasError}
    controls
    loop
    muted
    playsinline>
    <track kind="captions" />
  </video>
</div>
