describe('User Signup and Login', () => {
    const signUpUrl = '/users/sign_up';
    const signInUrl = '/users/sign_in';
    
    const user = {
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password123',
      first_name: 'John',
      last_name: 'Doe',
      address: '123 Main St',
      city: 'Springfield',
      zip: '12345',
      phone_number: '555-555-5555',
      province: 'Manitoba' // Assuming this province exists in your database
    };
    
    it('should sign up a new user', () => {
      cy.visit(signUpUrl);
    
      // Fill out the sign-up form
      cy.get('input[name="user[username]"]').type(user.username);
      cy.get('input[name="user[email]"]').type(user.email);
      cy.get('input[name="user[password]"]').type(user.password);
      cy.get('input[name="user[password_confirmation]"]').type(user.password);
      cy.get('input[name="user[first_name]"]').type(user.first_name);
      cy.get('input[name="user[last_name]"]').type(user.last_name);
      cy.get('input[name="user[address]"]').type(user.address);
      cy.get('input[name="user[city]"]').type(user.city);
      cy.get('input[name="user[zip]"]').type(user.zip);
      cy.get('input[name="user[phone_number]"]').type(user.phone_number);
      cy.get('select[name="user[province_id]"]').select(user.province);
    
      // Submit the form
      cy.get('input[type="submit"]').contains('Sign up').click();
    
      // Handle potential errors and check for successful signup
      cy.url().then((url) => {
        if (url.includes('/users/sign_up')) {
          cy.get('.error').should('not.exist'); // Check that there are no visible errors
        } else {
          cy.url().should('eq', Cypress.config().baseUrl + '/'); // Successful signup should redirect to the root path
        }
      });
    });
    
    it('should log in an existing user', () => {
      cy.visit(signInUrl);
    
      // Fill out the sign-in form
      cy.get('input[name="user[email]"]').type(user.email);
      cy.get('input[name="user[password]"]').type(user.password);
    
      // Submit the form
      cy.get('input[type="submit"]').contains('Log in').click();
    
      // Verify the user is logged in and redirected to the home page
      cy.url().should('eq', Cypress.config().baseUrl + '/');
    });
  });
  