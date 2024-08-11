describe('Cart and Checkout Tests', () => {
    const productPageUrl = '/products';
    const cartPageUrl = '/shopping_cart_items';
    const checkoutPageUrl = '/orders/new';

    beforeEach(() => {
        // Visit the login page
        cy.visit('/users/sign_in');

        // Wait for the form to be visible and available for interaction
        cy.get('form#new_user', { timeout: 10000 }).should('be.visible');

        // Enter the email
        cy.get('input#user_email').type('testuser@example.com'); // Replace with your test email

        // Enter the password
        cy.get('input#user_password').type('password123'); // Replace with your test password

        // Submit the form
        cy.get('input[name="commit"]').click();

        // Ensure the user is logged in
        cy.url().should('not.include', '/users/sign_in');
    });

    // Ignore uncaught exceptions to prevent the test from failing
    Cypress.on('uncaught:exception', (err, runnable) => {
        // We expect a 3rd party library to throw errors that we cannot control,
        // so we return false to prevent the test from failing
        if (err.message.includes('NetworkError when attempting to fetch resource')) {
            return false;
        }
        // Let Cypress fail the test for any other type of exception
        return true;
    });

    it('Happy path: User can add products to cart and checkout', () => {
        cy.visit(productPageUrl);

        // Ensure the Add to Cart button is visible and click it
        cy.get('form[action="/shopping_cart_items"]')
            .find('input[type="submit"]')
            .first()
            .should('exist')
            .should('be.visible')
            .click();

        // Go to the cart page
        cy.visit(cartPageUrl);

        // Ensure the Checkout button is visible and click it
        cy.get('a[href="/orders/new"]')
            .should('exist')
            .should('be.visible')
            .click();

        // Ensure we're on the checkout page
        cy.url().should('include', checkoutPageUrl);

        // Wait for dropdowns to be populated and visible
        cy.get('select[name="order[province_id]"] option')
            .should('have.length.greaterThan', 1); // Ensure options are loaded
        cy.get('select[name="order[province_id]"]').select('MB'); // Select Manitoba

        // Handle potential duplicates in the "Standard" shipping type
        cy.get('select[name="order[shipping_type_id]"]').then(($select) => {
            const options = $select.find('option');
            const standardOptions = options.filter((_, option) => option.text === 'Standard');
            if (standardOptions.length > 1) {
                // Select the first "Standard" option found
                cy.wrap($select).select(standardOptions.first().val());
            } else {
                cy.wrap($select).select('Standard');
            }
        });

        // Fill in the rest of the checkout form
        cy.get('input[name="order[receiver_name]"]').type('John Doe');
        cy.get('input[name="order[address]"]').type('123 Main St');
        cy.get('input[name="order[city]"]').type('Springfield');
        cy.get('input[name="order[postal_code]"]').type('12345');

        // Fill in the Stripe payment information
        cy.get('#card-element').should('be.visible'); // Assuming Stripe's card element is mounted here

        // Mock a successful Stripe payment (skipping actual Stripe API calls)
        cy.intercept('POST', '**/v1/payment_intents', {
            statusCode: 200,
            body: {
                id: 'pi_mocked',
                status: 'succeeded',
            },
        });

        // Submit the payment form
        cy.get('input[type="submit"][value="Place Order"]').click();

        // Confirm the order was placed successfully
        cy.contains('Order was successfully created and paid.');
    });

    it('Unhappy path: User cannot checkout with an empty cart', () => {
        // Go to the cart page
        cy.visit(cartPageUrl);

        // Attempt to click the checkout button
        cy.get('a[href="/orders/new"]').click();

        // Confirm the error message is displayed
        cy.contains('Your cart is empty.');
    });

    it('Unhappy path: User sees error with invalid credit card', () => {
        cy.visit(productPageUrl);

        // Ensure the Add to Cart button is visible and click it
        cy.get('form[action="/shopping_cart_items"]')
            .find('input[type="submit"]')
            .first()
            .should('exist')
            .should('be.visible')
            .click();

        // Go to the cart page
        cy.visit(cartPageUrl);

        // Ensure the Checkout button is visible and click it
        cy.get('a[href="/orders/new"]')
            .should('exist')
            .should('be.visible')
            .click();

        // Ensure we're on the checkout page
        cy.url().should('include', checkoutPageUrl);

        // Wait for dropdowns to be populated and visible
        cy.get('select[name="order[province_id]"] option')
            .should('have.length.greaterThan', 1); // Ensure options are loaded
        cy.get('select[name="order[province_id]"]').select('MB'); // Select Manitoba

        // Handle potential duplicates in the "Standard" shipping type
        cy.get('select[name="order[shipping_type_id]"]').then(($select) => {
            const options = $select.find('option');
            const standardOptions = options.filter((_, option) => option.text === 'Standard');
            if (standardOptions.length > 1) {
                // Select the first "Standard" option found
                cy.wrap($select).select(standardOptions.first().val());
            } else {
                cy.wrap($select).select('Standard');
            }
        });

        // Fill in the rest of the checkout form
        cy.get('input[name="order[receiver_name]"]').type('John Doe');
        cy.get('input[name="order[address]"]').type('123 Main St');
        cy.get('input[name="order[city]"]').type('Springfield');
        cy.get('input[name="order[postal_code]"]').type('12345');

        // Fill in the Stripe payment information
        cy.get('#card-element').should('be.visible'); // Assuming Stripe's card element is mounted here

        // Mock a failed Stripe payment (simulating invalid credit card)
        cy.intercept('POST', '**/v1/payment_intents', {
            statusCode: 402,
            body: {
                error: { message: 'Your card was declined.' },
            },
        });

        // Submit the payment form
        cy.get('input[type="submit"][value="Place Order"]').click();

        // Log the contents of the error element
        cy.get('#card-errors').invoke('text').then((text) => {
            cy.log('Card Error Text:', text);
        });

        // Confirm the error message is displayed
        cy.contains('Your card was declined.', { timeout: 10000 }).should('be.visible');
    });
});
