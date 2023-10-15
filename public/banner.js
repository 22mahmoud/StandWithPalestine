const elm = document.getElementById("standswithpalestine");

elm.addEventListener("load", () => {
  elm.height = elm.contentWindow.document.body.scrollHeight;
  elm.width = elm.contentWindow.document.body.scrollWidth;
});

