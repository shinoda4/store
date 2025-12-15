import {Controller} from "@hotwired/stimulus"
import TomSelect from "tom-select";
import "tom-select/dist/css/tom-select.css"

// Connects to data-controller="tom-select"
export default class extends Controller {
    connect() {
        console.log("connecting tom select");
        this.tom = new TomSelect(this.element, {
            create: false,
            sortField: {field: "text", direction: "asc"}
        })
    }

    disconnect() {
        this.tom?.destroy()
    }
}
