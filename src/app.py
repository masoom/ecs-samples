import flask
from flask import request, jsonify, abort

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/api', methods=['GET'])
def home():
    return "Sample API"

@app.route('/api/copyright', methods=['POST'])
def add_copyright_symbol():
    if not request.json or not 'input' in request.json:
        abort(400)
    else:
        userinput = request.json['input']
        dict = ['Oracle', 'oracle', 'Google', 'google', 'Microsoft', 'microsoft', 'Amazon', 'amazon']

        for company in dict:
            if company in userinput:
                userinput = userinput.replace(company, company + '©')
    return jsonify(userinput), 201

if __name__ == "__main__":
    app.run(host='0.0.0.0')
