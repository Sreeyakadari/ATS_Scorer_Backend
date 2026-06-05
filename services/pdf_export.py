import io
from bs4 import BeautifulSoup
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    PageBreak,
    Spacer,
)
from reportlab.lib.styles import getSampleStyleSheet


def html_to_text(html):
    soup = BeautifulSoup(html, "html.parser")
    return soup.get_text("\n")


def generate_combined_pdf(html_docs: dict[str, str]) -> bytes:
    buffer = io.BytesIO()

    doc = SimpleDocTemplate(buffer)

    styles = getSampleStyleSheet()

    elements = []

    for title, html_content in html_docs.items():

        elements.append(Paragraph(title, styles["Heading1"]))
        elements.append(Spacer(1, 12))

        text = html_to_text(html_content)

        for line in text.splitlines():
            line = line.strip()
            if line:
                elements.append(
                    Paragraph(line, styles["BodyText"])
                )

        elements.append(PageBreak())

    doc.build(elements)

    pdf_bytes = buffer.getvalue()
    buffer.close()

    return pdf_bytes