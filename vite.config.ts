import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import react from "@vitejs/plugin-react"

export default defineConfig({
  plugins: [
    RubyPlugin(),
    react()
  ],
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:3000",
        changeOrigin: true
      }
    }
  }
})
