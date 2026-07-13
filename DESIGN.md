---
version: alpha
name: CaratVault / Diamond Marketplace
description: >-
  A premium, high-trust digital marketplace for certified loose diamonds, bespoke engagement rings, 
  and high-jewelry investments. CaratVault combines elite luxury with institutional security tokens.
logo:
  src: https://images.unsplash.com/photo-1601121141461-9d6647bca1ed?auto=format&fit=crop&w=200&q=80
colors:
  surface: '#ffffff'
  surface-dim: '#f4f6f8'
  surface-bright: '#ffffff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f8fafc'
  surface-container: '#f1f5f9'
  surface-container-high: '#e2e8f0'
  surface-container-highest: '#cbd5e1'
  on-surface: '#0f172a'
  on-surface-variant: '#334155'
  inverse-surface: '#0f172a'
  inverse-on-surface: '#ffffff'
  outline: '#64748b'
  outline-variant: '#94a3b8'
  surface-tint: '#0a2540'
  primary: '#0a2540'
  on-primary: '#ffffff'
  primary-container: '#e2f1ff'
  on-primary-container: '#001833'
  inverse-primary: '#9bcaff'
  secondary: '#008060'
  on-secondary: '#ffffff'
  secondary-container: '#d3f4ea'
  on-secondary-container: '#002014'
  tertiary: '#b39250'
  on-tertiary: '#ffffff'
  tertiary-container: '#fbf3db'
  on-tertiary-container: '#2c1e00'
  error: '#dc2626'
  on-error: '#ffffff'
  error-container: '#fee2e2'
  on-error-container: '#450a0a'
  primary-fixed: '#d2e7ff'
  primary-fixed-dim: '#9bcaff'
  on-primary-fixed: '#001c3d'
  on-primary-fixed-variant: '#004791'
  secondary-fixed: '#b6eedb'
  secondary-fixed-dim: '#6de2bc'
  on-secondary-fixed: '#002116'
  on-secondary-fixed-variant: '#00523c'
  tertiary-fixed: '#f4e2b9'
  tertiary-fixed-dim: '#d7c28e'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#574319'
  background: '#ffffff'
  on-background: '#0f172a'
  surface-variant: '#f8fafc'
typography:
  display:
    fontFamily: Playfair Display, Cormorant Garamond, serif
    fontSize: 56px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: '-0.02em'
  headline-lg:
    fontFamily: Playfair Display, serif
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: '-0.01em'
  headline-md:
    fontFamily: Inter, Helvetica, sans-serif
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: '0em'
  title-lg:
    fontFamily: Inter, sans-serif
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: '0.01em'
  body-lg:
    fontFamily: Inter, sans-serif
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: '0.02rem'
  body-md:
    fontFamily: Inter, sans-serif
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: '0.01rem'
  label-md:
    fontFamily: Inter, sans-serif
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: '0.05em'
  label-sm:
    fontFamily: Inter, sans-serif
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: '0.08em'
rounded:
  sm: 2px
  DEFAULT: 4px
  md: 6px
  lg: 12px
  xl: 16px
  full: 9999px
spacing:
  unit: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 72px
  gutter: 32px
  container-max: 1280px
elevation:
  sm: 0 1px 3px rgba(15, 23, 42, 0.05)
  md: 0 4px 12px rgba(15, 23, 42, 0.08)
  lg: 0 12px 32px rgba(15, 23, 42, 0.12)
layout:
  containerMaxWidth: 1280px
  gridColumns: 12
components:
  button-primary:
    backgroundColor: '{colors.primary}'
    textColor: '{colors.on-primary}'
    typography: '{typography.label-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 14px 32px
    height: 48px
    border: none
  button-primary-hover:
    backgroundColor: '#133959'
    textColor: '{colors.on-primary}'
    transition: background-color 250ms cubic-bezier(0.4, 0, 0.2, 1)
  button-secondary:
    backgroundColor: transparent
    textColor: '{colors.primary}'
    typography: '{typography.label-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 14px 32px
    height: 48px
    border: 1px solid {colors.primary}
  button-secondary-hover:
    backgroundColor: '{colors.primary-container}'
    textColor: '{colors.on-primary-container}'
    transition: all 200ms ease-in-out
  button-tertiary:
    backgroundColor: '{colors.tertiary}'
    textColor: '{colors.on-tertiary}'
    typography: '{typography.label-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 14px 32px
    height: 48px
    border: none
  button-tertiary-hover:
    backgroundColor: '#9a7b3e'
    transition: background-color 200ms ease-in-out
  card:
    backgroundColor: '{colors.surface}'
    rounded: '{rounded.md}'
    padding: '{spacing.md}'
    boxShadow: '{elevation.sm}'
    border: 1px solid {colors.surface-container-high}
  card-hover:
    backgroundColor: '{colors.surface}'
    boxShadow: '{elevation.md}'
    borderColor: '{colors.outline-variant}'
    transition: all 250ms ease-in-out
  input-field:
    backgroundColor: '{colors.surface}'
    textColor: '{colors.on-surface}'
    typography: '{typography.body-md}'
    rounded: '{rounded.sm}'
    padding: 12px 14px
    border: 1px solid {colors.surface-container-highest}
    height: 44px
  input-field-focus:
    backgroundColor: '{colors.surface}'
    borderColor: '{colors.primary}'
    boxShadow: 0 0 0 3px rgba(10, 37, 64, 0.1)
    transition: all 150ms ease-in-out
  badge:
    backgroundColor: '{colors.secondary-container}'
    textColor: '{colors.on-secondary-container}'
    typography: '{typography.label-sm}'
    rounded: '{rounded.sm}'
    padding: 4px 8px
    display: inline-block
  badge-primary:
    backgroundColor: '{colors.tertiary-container}'
    textColor: '{colors.on-tertiary-container}'
    typography: '{typography.label-sm}'
    rounded: '{rounded.sm}'
  list-item:
    backgroundColor: transparent
    rounded: '{rounded.sm}'
    padding: '{spacing.sm}'
    textColor: '{colors.on-surface}'
  list-item-hover:
    backgroundColor: '{colors.surface-container-low}'
    textColor: '{colors.primary}'
    transition: all 150ms ease-in-out
---

## Overview

The Diamond Marketplace Design System is built for a premium, high-trust digital trade ecosystem. Unlike standard fashion e-commerce apps that use softer, playful visuals, a diamond marketplace must invoke ultimate security, geometric precision, and institutional confidence. The interface relies heavily on architectural layouts, sharp grid boundaries, and an elite color palette balancing Deep Vault Blue (#0a2540) and Platinum Silver, accented by Natural Emerald Green (#008060) for certificate compliance and Champagne Gold (#b39250) for bespoke tier elements. 

The brand voice is authoritative, completely transparent, and deeply informative. Users range from private collectors purchasing bespoke assets to B2B wholesalers evaluating 4C data matrices. Tone strings emphasize technical certifications over emotional catchphrases: "GIA Certified Laser Inscription" instead of "magical sparkle." 

## Colors

Color tokens mirror the environments of luxury bank vaults and high-end gemological laboratories. Deep Vault Blue (#0a2540) establishes institutional stability and drives primary user actions. Natural Emerald Green (#008060) handles positive compliance labels, GIA/IGI certificate verification tags, and market price stability indicators. Champagne Gold (#b39250) is leveraged exclusively to isolate elite asset listings, investment-grade parcels, and premium advisory services.

Surfaces default to clean, ultra-bright whites (#ffffff) paired with an incremental slate background stack (surface-container-low at #f8fafc to high at #e2e8f0). This minimizes visual fatigue while rendering high-resolution, multi-angle stone matrices and 360-degree video scopes.

## Typography

The typography system uses an editorial, high-contrast serif structure for prestige displays, paired with an industrial neo-grotesque sans-serif for heavy numerical and tabular layout systems. Editorial display headers utilize Playfair Display to anchor lifestyle collections and custom ring-building funnels. 

All search lists, diamond comparison grids, and 4C (Carat, Cut, Clarity, Color) parameter charts rely on Inter. This guarantees legible, high-density data visualization even on compact mobile devices. Tracking rules are strict: labels use 0.05em spacing to preserve structure under heavy capitals, while body regions use a comfortable 24px line-height to make complex gemstone analysis accessible.

## Layout

The architecture rests on an expansive, ultra-stable 12-column grid with a maximum scale of 1280px. Spacing protocols scale linearly based on an 8px engine to align technical data blocks neatly. 

While fashion apps lean into fluid, borderless components, this system uses sharp layout structures. Diamond grid blocks, clarity maps, and pricing charts maintain exact paddings (24px default md spacing) and explicitly defined container borders. This technical layout layout replicates the meticulous nature of a diamond sorting tray.

## Elevation & Depth

To maximize clarity, the visual field minimizes soft drop-shadow systems in favor of clean strokes and crisp container edges. Default components rest perfectly flat on Level 1 (Base/Flat). 

Level 2 (Elevated: 0 4px 12px rgba(15, 23, 42, 0.08)) is triggered when elements are highlighted during interactive sorting states or when a user isolates a specific stone for a side-by-side comparison. Level 3 (Maximum Depth) is exclusively reserved for modal filter menus, interactive ring-configurator drawers, and raw diamond certificate popups.

## Shapes

Shapes follow a "Chiseled Precision" framework. Mimicking diamond facets, corner radiuses are kept distinctly tight. General UI modules, inputs, and functional buttons sit at a sharp 4px or 2px radius, avoiding rounded, playful contours to signal a technical, secure trading portal. Large containers like full-view detail sheets max out at a strict 12px-16px.

## Components

### Action Elements
Buttons utilize a precise, boxy footprint. Primary buttons employ Deep Vault Blue (#0a2540) filled with white text, measuring a prominent 48px height for clear tap intent. Hover states transition dynamically over 250ms to #133959 using an intentional cubic-bezier curve. Secondary elements feature a 1px solid blue framework with transparent surfaces. Input zones prioritize high text contrast with crisp slate bounds that step up to a distinct 3px ring layout during live filter focusing.

## Do's and Don'ts

**Do**
- Do use Deep Vault Blue (#0a2540) for core conversion pathways and primary trading functions.
- Do display certified gem grading specifications (GIA/IGI) directly alongside price configurations.
- Do employ sharp, low border radiuses (2px to 6px max) to convey technical, premium industrial design.
- Do implement highly responsive, explicit table matrices when mapping out 4C pricing specifications.
- Do keep background tones highly controlled (Slate/White) to prevent color pollution from altering perceived diamond clarity images.

**Don't**
- Don't use bright neon gradients, playful pinks, or overly soft pastel surfaces anywhere in the core trading flow.
- Don't use heavy, blurred drop-shadow configurations that mimic casual social platforms.
- Don't replace structured technical data filters with vague text descriptions.
- Don't allow diamond imagery to bleed or wrap arbitrarily without keeping standard, crisp card borders intact.
- Don't use casual or hyper-trendy fonts for labels; maintain clean sans-serif layouts for all structural figures.