return {
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            -- accept whole completion
            -- accept = '<C-Space>',
            accept = '<C-A>',
            -- accept one line
            -- accept_line = '<S-Tab>',
            accept_line = '<C-a>',
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            -- accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<C-ö>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<C-ä>',
            -- dismiss = '<A-e>',
          },
        },

        provider = 'openai_fim_compatible',
        n_completions = 1, -- recommend for local model for resource saving
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as an good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        context_window = 256,
        request_timeout = 60,
        -- notify = 'debug',
        provider_options = {
          openai_fim_compatible = {
            -- For Windows users, TERM may not be present in environment variables.
            -- Consider using APPDATA instead.
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            -- model = 'qwen2.5-coder:32b',
            model = 'qwen2.5-coder:14b',
            optional = {
              max_tokens = 56,
              top_p = 0.9,
            },
          },
        },
      }
    end,
  },
}
