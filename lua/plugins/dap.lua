return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("nvim-dap").setup()
      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          -- 💀 Make sure to update this path to point to your installation
          args = { "/usr/share/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
    end,
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    lazy = true,
  },
}
