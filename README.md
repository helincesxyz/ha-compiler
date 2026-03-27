# ha-compiler

A compiler for **HA** (Home Automation) — a domain-specific language for writing smart home automation rules in clean, readable syntax.

 Every phase of the pipeline is implemented from first principles: scanner → parser → semantic analyzer → Home Assistant YAML codegen. 

 Built from scratch in parallel with, and inspired by CS305 (Programming Languages) at Sabanci University, lectured by Husnu Yenigun. 
---

## The Problem

Smart home automation with platforms like Home Assistant means writing YAML like this:

```yaml
automation:
  - alias: "Evening Wind Down"
    trigger:
      - platform: time
        at: "21:00:00"
    condition:
      - condition: time
        after: "21:00:00"
        before: "23:00:00"
    action:
      - service: light.turn_on
        entity_id: light.living_room
        data:
          effect: ambient
      - service: switch.turn_off
        entity_id: switch.plug
```

HA lets you write the same thing as:

```
rule "EveningWindDown" {
    when time in 21:00..23:00;
    then Light = ambient and Plug = off;
}
```
The long-term goal is a personal automation system I can maintain, extend, and fully own. As I add devices to my apartment (lights, sensors, air purifier, humidifier, smart thermostat)  I'll write `.ha` files for them, commit them to this repo, and compile them locally (Raspberry Pi + Home Assistant). 

---

## Build & Run

**Requirements:** `flex`, `bison`, `gcc`

```bash
# Scanner
flex hw.flx
gcc -o scanner lex.yy.c -lfl
./scanner < examples/evening.ha

# Parser
bison -d hw.y
flex hw.flx
gcc -o parser lex.yy.c hw.tab.c -lfl
./parser < examples/evening.ha
# → OK or ERROR
```

---

## Structure

ha-compiler/
├── README.md
├── scanner/
│   └── hw.flx              # Flex scanner — tokens, comments, time literals
├── parser/
│   └── hw.y                # Bison grammar — full CFG for HA language
├── semantic/               # (in progress)
├── codegen/                # (planned — .ha → Home Assistant YAML)
└── examples/
    └── my-apartment.ha     # Real automations for my apartment


---

## Devlog

| Date | Milestone |
|---|---|
| Mar 2026 | Scanner complete — all tokens, nested comments, time literals |
| Apr 2026 | Parser complete — full CFG, ambiguity resolved |
| Apr 2026 | Semantic analyzer — type checking, undefined device detection |
| *coming* | YAML codegen — first end-to-end `.ha` → Home Assistant output |
| *coming* | Running on Raspberry Pi in my apartment |
| ongoing  | New .ha files as I add devices to my apartment |
---

## Roadmap

The compiler phases may follow the CS305 + CS402 curriculum at Sabancı University, or end earlier/later (Mar 2026- Dec 2026). The end goal is a working CLI:

```bash
ha-compile morning.ha --output automations.yaml
```

Drop `automations.yaml` into Home Assistant. Done.

---

*Questions, fixing or ideas — open an issue.*