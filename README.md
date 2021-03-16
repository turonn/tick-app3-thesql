# README

<h3>1. Install Stripe CLI</h3>

To run this program you will need the stripe Comand Line Interface. To install the Stripe CLI with homebrew, run:

<code>brew install stripe/stripe-cli/stripe</code>

Additional instructions for installing the Stripe Command Line Interface can be found here: https://stripe.com/docs/stripe-cli

Then, you will need to log in to a Stripe. Run the following command to log in:

<code>stripe login</code>

Follow the terminal prompts to sync your Stripe account with the CLI.

Edit your Rails Credentials file to include your stripe public, private, and webhook secret keys. Run the following command and nest your credentials here:

<code>EDITOR=vi bin/rails credentials:edit</code>

For those new to VI, type <code>i</code> wile in the "strange" view to enter the editor and <code>:wq</code> to quit and save.

Finally, you will need to run the Stripe CLI in conjunction to the rails server locally. Run the following code in an open terminal to tell Stripe to listen to your local machiene for webhooks:

<code>stripe listen --forward-to localhost:3000/webhooks</code>

<h3>2. Known issues</h3>

If your rails server crashes, you can force kill it with the following command:

<code>sudo kill -9 $(lsof -i :3000 -t)</code>

At times the Stripe CLI will stop listening to the rails server. If you stop getting responses from the Stripe CLI, just close it and restart it again.

<h3>Usage</h3>

Parents and fans will be able to browse future upcoming games on the root path. They will select the tickets they would like to purchase here and they will be redirected to the cart view. Inside the cart view they can adjust the number of tickets they want to purchase for that game and add other games to the cart if they wish.

When they hit checkout, they will be prompted to sing in or create an account. After they are logged in, they will be redirected to Stripe for payment. Upon successfull completion of checkout payment, the tickets they have purchased will be genereated under "my tickets" as a part of "my account."

Tickets for games occuring in the future that have not been used will populate in the "my tickets" view nested under the appropriate game.

Administrators can be granted administrator privledges to view '/admin'.

<h3>Future improvements</h3>

<ul>
  <li>Track webhooks to rerun in case of failure. Perhaps a WebhookEvents Model</li>
  <li>Create an OAuth system so fans will not have to creat a new account</li>
  <li>Host project to AWS</li>
  <li>Integrate with Google Wallet and Apple Wallet for ticket display</li>
  <li>Send copy of tickets to user in an email after purchase</li>
  <li>Styling</li>
  <ul>
    <li>Stylize the game cards so that the calendar looks like a calendar</li>
    <li>Stylize the cart view for mobile so they don't have to side scroll to see all details</li>
    <li>Stylize ticket views to be an image carosel</li>
  </ul>
</ul>
