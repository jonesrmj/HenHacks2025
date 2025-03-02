async function sendData() {

const apiUrl = 'http://127.0.0.1:8000/API';

const passwordInput = {
    pass: passward,
};


const requestOptions = {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(passwordInput),
};


fetch(apiUrl, requestOptions)
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    outputElement.textContent = JSON.stringify(passwordInput, null, 2);
  })
  .catch(error => {
    console.error

('Error:', error);
  });
}