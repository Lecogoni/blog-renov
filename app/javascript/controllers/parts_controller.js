import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  sort() {
    let part = document.getElementById("parts-elements");
    let part_items = Array.from(
      document.getElementsByClassName("part-item")
    );
    let parts = part_items.map((ele, index) => {
      return { id: ele.dataset.id, position: index + 1 };
    });

    //console.log(parts);

    part.dataset.parts = JSON.stringify(parts);
    this.stimulate("PartsReflex#sort", part);
  }
}
