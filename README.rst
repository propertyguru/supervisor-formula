==================
supervisor-formula
==================

A saltstack formula that is installs supervisor and adds programs.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``supervisor``
--------------

Installs the supervisor package, and starts the associated supervisor programs.


Tested on Debian, Ubuntu 14, Ubuntu 16 and CentOS 7. CentOS 6 doesn't work.

Warning
=======

This formula works with supervisor version 3. It does NOT work with v2 so it doesn't work with CentOS 6 (repo version is v2).

