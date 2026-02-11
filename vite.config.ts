import { vitePlugin as remix } from "@remix-run/dev";
import { defineConfig, type UserConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

installGlobals();

// Related: https://github.com/remix-run/remix/issues/2835#issuecomment-1144102176
// Replace the TS compiler's way of doing `import.meta.env` with Vite's
const define: UserConfig["define"] = {
  // This is used by `@shopify/shopify-app-remix`
  "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV),
};

export default defineConfig({
  define,
  plugins: [
    remix({
      ignoredRouteFiles: ["**/.*"],
    }),
    tsconfigPaths(),
  ],
  build: {
    assetsInlineLimit: 0,
  },
  server: {
    port: Number(process.env.PORT || 3000),
    warmup: {
      clientFiles: ["./app/entry.client.tsx", "./app/root.tsx", "./app/routes/**/*.tsx"],
    },
  },
  optimizeDeps: {
    include: ["@shopify/polaris"],
  },
});

function installGlobals() {
  // https://remix.run/docs/en/main/other-api/node#installglobals
  const { installGlobals } = require("@remix-run/node");
  installGlobals();
}
