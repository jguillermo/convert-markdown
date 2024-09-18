const mj = require('mathjax-node');
const fs = require('fs/promises');

// Configurar MathJax
mj.config({
  MathJax: {
    tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      displayMath: [['$$', '$$'], ['\\[', '\\]']]
    }
  }
});
mj.start();

// Función para convertir LaTeX a texto plano de manera asincrónica
function latexToText(latex) {
  return new Promise((resolve, reject) => {
    mj.typeset({
      math: latex,
      format: "TeX", // Formato de entrada es LaTeX
      mml: false,
      svg: false,
      html: true,
      ascii: false, // Convertir a ASCII
      speakText: false, // No necesitamos texto para síntesis de voz
    }, (data) => {
      if (data.errors) {
        reject(data.errors);
      } else {
        resolve(data.html);
      }
    });
  });
}

// Función principal para procesar el archivo Markdown
async function processMarkdown() {
  try {
     // Cargar clipboardy dinámicamente
     const clipboardy = await import('clipboardy');

     // Leer el contenido del portapapeles
     const markdown = await clipboardy.default.read();

    // Expresión regular para detectar LaTeX
    const latexRegex = /(\$\$[^$]*\$\$)|(\$[^$]*\$)|\\\[([^]*?)\\\]|\\\(([^]*?)\\\)/g;

    // Obtener todas las expresiones LaTeX en un array
    const latexMatches = [...markdown.matchAll(latexRegex)].map(match => match[0]);

    //console.log("Expresiones LaTeX encontradas:", latexMatches);

    // Convertir todas las expresiones LaTeX a texto plano
    const convertedLatexArray = await Promise.all(
      latexMatches.map(async (latex) => {
        // Eliminar los delimitadores de LaTeX antes de la conversión
        const latexContent = latex.replace(/^\$\$|^\$|\\\(|\\\[|\$\$$|\$$|\\\)|\\\]$/g, '');
        try {
          const converted = await latexToText(latexContent);
          return converted;
        } catch (error) {
          console.error('Error al convertir LaTeX:', error);
          return latex; // Si falla la conversión, devolver la expresión original
        }
      })
    );

    //console.log("Expresiones convertidas:", convertedLatexArray);

    // Reemplazar las expresiones LaTeX originales con las versiones convertidas
    let processedMarkdown = markdown;
    latexMatches.forEach((latex, index) => {
      processedMarkdown = processedMarkdown.replace(latex, convertedLatexArray[index]);
    });

    // Guardar el archivo procesado en una salida
    await fs.writeFile('temp.md', processedMarkdown, 'utf8');
    console.log('Archivo procesado y guardado como temp.md');
  } catch (error) {
    console.error('Error al procesar el archivo:', error);
  }
}

// Procesar el archivo Markdown llamado "temp.md"
processMarkdown();
