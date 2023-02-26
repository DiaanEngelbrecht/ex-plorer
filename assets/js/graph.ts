import * as d3 from "d3";

interface Node {
  name?: string;
  pid?: string;
  port?: string;
  children: Node[];
}

const processGraph = {
  registerHook: function(hook: Object) {
    hook["graph"] = {
      tree(this: { el: HTMLElement }) {
        let data : Node = JSON.parse(this.el.dataset.processTree || '');
        return data;
      },

      mounted(this: { el: HTMLElement, tree: () =>  Node}) {
        let i = 0;
        let root = d3.hierarchy(this.tree()).eachBefore(d => d.index = i++);

        const nodes = root.descendants();
        let nodeSize = 5;
        let container =  document.getElementById("graph");
        const svg = d3.create("svg")
            .attr("viewBox", [-nodeSize / 2, -nodeSize * 3 / 2, 300, (nodes.length + 1) * nodeSize])
            .attr("font-family", "sans-serif")
            .attr("font-size", 3.5)
            .style("overflow", "visible");

        const link = svg.append("g")
            .attr("fill", "none")
            .attr("stroke", "#999")
          .selectAll("path")
          .data(root.links())
          .join("path")
            .attr("stroke-width", 0.5)
            .attr("d", d => `
              M${d.source.depth * nodeSize},${d.source.index * nodeSize}
              V${d.target.index * nodeSize}
              h${nodeSize}
            `);

        const node = svg.append("g")
          .selectAll("g")
          .data(nodes)
          .join("g")
            .attr("transform", d => `translate(0,${d.index * nodeSize})`);

        node.append("circle")
            .attr("cx", d => d.depth * nodeSize)
            .attr("r", 1.8)
            .attr("fill", d => d.children ? "#333" : "#999");

        node.append("text")
            .attr("fill", "#fff")
            .attr("dy", "0.32em")
            .attr("x", d => d.depth * nodeSize + 6)
            .text(d => `${d.data.pid || d.data.port} ${d.data.name || ""}`);

        container?.append(svg.node());
      },

      destroyed() {
        console.log("Destroyed");
      },

      updated(this: { el: HTMLElement, tree: () =>  Node }) {
        console.log("Updating")
        let i = 0;
        let root = d3.hierarchy(this.tree()).eachBefore(d => d.index = i++);

        const nodes = root.descendants();
        let nodeSize = 5;
        let container =  document.getElementById("graph");
        const svg = d3.create("svg")
            .attr("viewBox", [-nodeSize / 2, -nodeSize * 3 / 2, 300, (nodes.length + 1) * nodeSize])
            .attr("font-family", "sans-serif")
            .attr("font-size", 3.5)
            .style("overflow", "visible");

        const link = svg.append("g")
            .attr("fill", "none")
            .attr("stroke", "#999")
          .selectAll("path")
          .data(root.links())
          .join("path")
            .attr("stroke-width", 0.5)
            .attr("d", d => `
              M${d.source.depth * nodeSize},${d.source.index * nodeSize}
              V${d.target.index * nodeSize}
              h${nodeSize}
            `);

        const node = svg.append("g")
          .selectAll("g")
          .data(nodes)
          .join("g")
            .attr("transform", d => `translate(0,${d.index * nodeSize})`);

        node.append("circle")
            .attr("cx", d => d.depth * nodeSize)
            .attr("r", 1.8)
            .attr("fill", d => d.children ? "#333" : "#999");

        node.append("text")
            .attr("fill", "#fff")
            .attr("dy", "0.32em")
            .attr("x", d => d.depth * nodeSize + 6)
            .text(d => `${d.data.pid || d.data.port} ${d.data.name || ""}`);

        container?.append(svg.node());
      }
    }
  }
}

export default processGraph;
