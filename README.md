# README

<h3>1. Install Stripe CLI</h3>

To run this program you will need the stripe Comand Line Interface. To install the Stripe CLI with homebrew, run:

<code>brew install stripe/stripe-cli/stripe</code>

Then, you will need to log in to a Stripe. Run the following command to log in:

<code>stripe login</code>

Follow the terminal prompts to sync your Stripe account with the CLI.

Finally, you will need to run the Stripe CLI in conjunction to the rails server locally. Run the following code in an open terminal to tell Stripe to listen to your local machiene for webhooks:

<code>stripe listen --forward-to localhost:3000/webhooks</code>

<h3>2. Known issues</h3>

If your rails server crashes, you can force kill it with the following command:

<code>sudo kill -9 $(lsof -i :3000 -t)</code>

At times the Stripe CLI will stop listening to the rails server. If you stop getting responses from the Stripe CLI, just close it and restart it again.
