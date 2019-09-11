export function init_todos() {
  const todos = document.getElementsByClassName("todo");
  for (let todo of todos) {
    todo_hover_handler(todo);
  }
}

function todo_hover_handler(element) {
  const activeClass = "active";
  const todoClassList = element.classList;
  const destroyBtnClassList = element.querySelector(".destroy").classList;

  element.addEventListener("mouseover", () => {
    todoClassList.add(activeClass);
    destroyBtnClassList.add(activeClass);
  });

  element.addEventListener("mouseout", () => {
    todoClassList.remove(activeClass);
    destroyBtnClassList.remove(activeClass);
  });
}
