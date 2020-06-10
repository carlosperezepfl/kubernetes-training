var cube = document.querySelector('.cube');
var currentClass = '';
let classes = ["front", "right", "bottom", "left", "back", "top"];
var index = 0;

function changeSide() {
  index = (index+1) % 6;
  var face = classes[index];
  var showClass = 'show-' + face;
  if ( currentClass ) {
    cube.classList.remove( currentClass );
  }
  cube.classList.add( showClass );
  currentClass = showClass;
}

// set initial side
changeSide();
let timerId = setInterval(() => changeSide(), 2000);
