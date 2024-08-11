const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    browser: 'chrome',
    chromeWebSecurity: false,
    args: ['--no-sandbox', '--disable-gpu'],
    
    // Base URL for your application
    baseUrl: 'http://127.0.0.1:3000', // Replace with the actual base URL of your app if different

    // Add the specPattern to look for test files in cypress/integration/
    specPattern: 'cypress/integration/**/*.{js,jsx,ts,tsx}',

    // If you decide to move your files to cypress/e2e/ in the future:
    // specPattern: 'cypress/e2e/**/*.{js,jsx,ts,tsx}',
  },
});
