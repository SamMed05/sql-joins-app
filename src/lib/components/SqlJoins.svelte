<script>
  import { onMount } from 'svelte'
  import ClipboardJS from 'clipboard'
  import hljs from '@utils/highlight'
  import { DEFAULT_VALUE, SQL_MAP } from '@utils/constants'
  import VennDiagram from './VennDiagram.svelte'

  let copyButtonEl = $state(null)
  let isButtonClicked = $state(false)

  let descriptionText = $state(SQL_MAP[DEFAULT_VALUE].description)
  let sqlText = $state(SQL_MAP[DEFAULT_VALUE].sql.trim())
  let sqlExample = $derived(hljs.highlight(sqlText, { language: 'sql' }).value)
  let isButtonDisabled = $derived(sqlText.length === 0)

  const handleClick = (state = DEFAULT_VALUE) => {
    let { sql, description } = SQL_MAP[state]
    sqlText = sql.trim()
    descriptionText = description
  }

  onMount(() => {
    let timer = null

    const clipboard = new ClipboardJS(copyButtonEl, {
      text: () => sqlText
    })

    clipboard.on('success', () => {
      if (timer) {
        clearTimeout(timer)
      }

      if (isButtonDisabled) {
        return
      }

      isButtonClicked = true

      timer = setTimeout(() => {
        isButtonClicked = false
        timer = null
      }, 1000)
    })

    return () => {
      clipboard.destroy()
    }
  })
</script>

<style lang="postcss">
  .visualizer-block {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .venn-diagram {
    padding: 1rem;
  }

  .sql-description {
    color: #c1bebe;
  }

  .sql-code-block {
    width: 100%;
    position: relative;
  }

  .sql-code-pre {
    margin: 1rem 0;
    min-height: 0;
    line-height: 1.1;
    width: 100%;
    box-sizing: border-box;
  }

  .sql-code-text {
    padding: 1rem;
    width: 100%;
    box-sizing: border-box;
  }

  .copy-button-block {
    width: 100%;
  }

  .copy-button {
    line-height: 1.6;
    background: #4b382e;
    border: 1px solid #ff8e5a;
    color: #d5d5d5;
    cursor: pointer;
    user-select: none;
  }

  .copy-button:hover,
  .copy-button:active {
    background: #5c3d2d;
  }

  .copy-button:disabled,
  .copy-button[disabled] {
    background: #3b3b3b;
    border: 1px solid #575656;
  }

  .copy-button-copied {
    background: #c25827;
  }

  .copy-button-copied:hover,
  .copy-button:active {
    background: #c25827;
  }

  /* button positioned inside the code area */
  .code-copy-button {
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    z-index: 10;
    padding: 0.5rem;
    font-size: 0.9rem;
    border-radius: 3px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .code-copy-button.hidden {
    display: none;
  }

  .copy-icon {
    width: 1.2rem;
    height: 1.2rem;
    fill: currentColor;
  }
</style>

<div class="visualizer-block">
  <div class="venn-diagram">
    <VennDiagram handleClick={handleClick} />
  </div>

  <p class="sql-description">{descriptionText}</p>

  <div class="sql-code-block">
    <!-- eslint-disable svelte/no-at-html-tags -->
    <div class="code-container">
      <button
        bind:this={copyButtonEl}
        class="copy-button code-copy-button"
        class:hidden={isButtonDisabled}
        class:copy-button-copied={isButtonClicked}
        title="Click to copy sql">
        <svg class="copy-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          {#if isButtonClicked}
            <!-- Checkmark icon -->
            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
          {:else}
            <!-- Clipboard icon -->
            <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
          {/if}
        </svg>
      </button>
      <pre class="sql-code-pre"><code class="sql-code-text hljs language-sql">{@html sqlExample}</code></pre>
    </div>
  </div>
</div>
