handleTicketChange = () => {
  document.getElementById('cart-form').submit()
}

const csrfToken = document.querySelector("[name='csrf-token']").content

var checkoutButton = document.getElementById("checkout-button");
  checkoutButton.addEventListener("click", function () {
    fetch("/cart/testing", {
      method: "POST",
      headers: { "X-CSRF-Token": csrfToken }
    })
      .then(function (response) {
        return response.json();
      })
      .then(function (session) {
        return stripe.redirectToCheckout({ sessionId: session.id });
      })
      .then(function (result) {
        // If redirectToCheckout fails due to a browser or network
        // error, you should display the localized error message to your
        // customer using error.message.
        if (result.error) {
          alert(result.error.message);
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
      });
  });