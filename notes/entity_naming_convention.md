# 

I've opted to build my own naming convention for the sake of visually grouping, programmatically selecting, and human-memory recall.

A particular naming convention may likely span multiple domains, and starts with the entity_id *name* itself.

Example:
```
<domain>.<convention>_<rest_of_name>
```

## HVAC

Convention: `hvac`

Entities related to tracking, displaying, and controlling the HVAC will all fall under this category.

Example:
```

```

## 

Convention: `presence`

This types of Entities targets everything about knowing who's home, where everyone is, and what to do when presence detection changes.

Example:
```

```

## Intent

Convention: `intent`

These are targeting *Intents*, or  that represent an intention within the system.
 (ie, Alexa, Google Home, etc).

Example:
```
input_boolean.intent_expecting_guests
```