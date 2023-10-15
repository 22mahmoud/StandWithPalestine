window.addEventListener("message", function (event) {
  if (event.data?.type !== "standwithpalestine_height") return;
  const height = event.data?.data?.height;

  const elm = document.querySelector("#standswithpalestine");

  elm.height = height;
  elm.width = "100%";
});
