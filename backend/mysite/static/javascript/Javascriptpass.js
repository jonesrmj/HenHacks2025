async function sendData(password) {

const apiUrl = 'http://127.0.0.1:8000/API/';

const passwordInput = {
    pass: password,
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
    dict = JSON.parse(JSON.stringify(data, null, 2));
    document.getElementById("outputElement").innerHTML = dict;
    document.getElementById("DataDisplay").innerHTML =  dict["strengh"];
    document.getElementById("Datainfo").innerHTML = dict["breaches"];
    document.getElementById("Suggestioninfo").innerHTML = dict["AI"];
  })
  .catch(error => {
    console.error

('Error:', error);
  });
}