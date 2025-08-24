# anki-ccse

Anki deck for the Spanish CCSE preparation manual.

In Anki software, import the deck file `ccse.apkg`.

## Card Sample

### (front)

__España es…__

- una monarquía parlamentaria.
- una república federal.
- una monarquía federal.

### (back)

__España es…__  
__una monarquía parlamentaria.__  
<span style="color:lightgray;">~~una república federal.~~</span>  
<span style="color:lightgray;">~~una monarquía federal.~~</span>

## For maintainers

### How to create ccse.apkg from scratch in Anki software

Tools / Manage Note Types  
Add a note type from type `Add: Basic`  
Note type name: `choice_abc`

Ensure the type `choce_abc` has the following sequence of fields:

1. `question_id`
2. `question`
3. `front_a`
4. `front_b`
5. `front_c`
6. `back_a`
7. `back_b`
8. `back_c`

Create a new deck called `ccse`.
Edit its card template and make the following template fields as follow.

_(Front Template)_

```
<b>{{question}}</b>
{{#front_a}}<br>&#x2022; {{front_a}}{{/front_a}}
{{#front_b}}<br>&#x2022; {{front_b}}{{/front_b}}
{{#front_c}}<br>&#x2022; {{front_c}}{{/front_c}}
```

_(Back Template)_

```
<b>{{question}}</b>
{{#back_a}}{{back_a}}{{/back_a}}
{{#back_b}}{{back_b}}{{/back_b}}
{{#back_c}}{{back_c}}{{/back_c}}
```

_(Styling)_

```
.card {
    font-family: arial;
    font-size: 20px;
    line-height: 1.5;
    text-align: center;
    color: black;
    background-color: white;
}

.yes {
    font-weight: bold;
}

.no {
    color: lightgray;
    text-decoration: line-through;
}
```


Import file `ccse_notes.txt`.
Preview some cards and check if the deck behaves ok.

Export the deck:

- File / Export
- Export format: Anki Deck Package
- Include: ccse
- All check boxes off
- Save to `ccse.apkg`


### How to update ccse_notes.txt

Update or increment the file pairs (`*.questions` / `*.answers`).

In a bash prompt:

```
$ ./build.sh
Processing tarea_1...
Processing tarea_2...
Processing tarea_3...
Processing tarea_4...
Processing tarea_5...
Generated: ccse_notes.txt
```


### How to update *.questions and *.answers

Edit with a simple text editor.

Download the Manual CCSE from
[Instituto Cervantes](https://examenes.cervantes.es/es/ccse/preparar-prueba)
and open it with a pdf reader.

Copy all questions from a section and paste to the `*.questions` file.
Manually review all file and ensure that:

- each question starts with a numeric id followed by the question text in a single line.
- each option starts with `a)`, `b)` or `c)` and is contained in a single line.
- options are in sequence  -- `a`, `b` and `c` (if exists).

Copy all answers from the related section and paste to the related `*.answers` file.

