const csrfToken = document.querySelector("[name='csrf-token']").content

var purchase = {
items: [{ id: "xl-tshirt" }]
};
// Disable the button until we have Stripe set up on the page
//document.querySelector("button").disabled = true;

var elements = stripe.elements();

//style the card input
var style = {
  base: {
    color: "#32325d",
    fontFamily: 'Arial, sans-serif',
    fontSmoothing: "antialiased",
    fontSize: "16px",
    "::placeholder": {
      color: "#32325d"
    }
  },
  invalid: {
    fontFamily: 'Arial, sans-serif',
    color: "#fa755a",
    iconColor: "#fa755a"
  }
};

//import card element and mount iframe onto DOM
var card = elements.create("card", { style: style });
card.mount("#card-element");

card.on("change", function (event) {
  // Disable the Pay button if there are no card details in the Element
  document.querySelector("button").disabled = event.empty;
  document.querySelector("#card-error").textContent = event.error ? event.error.message : "";
});

var form = document.getElementById("payment-form");
form.addEventListener("submit", function(event) {
  event.preventDefault();
  fetch('/cart/create_payment_intent', {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(
      purchase
      )
    })
    .then(function(result) {
      return result.json();
    })
    .then(function(data) {
      payWithCard(stripe, card, data.clientSecret);
    });
  })

var payWithCard = function(stripe, card, clientSecret) {
  //loading(true);
  console.log(stripe)
  stripe
    .confirmCardPayment(
      clientSecret, 
      {
        payment_method: {
          card: card
        }
      }
    )
    .then(function(result) {
      if (result.error) {
        // Show error to your customer
        showError(result.error.message);
      } else {
        // The payment succeeded!
        orderComplete(result.paymentIntent.id);
      }
    });
};