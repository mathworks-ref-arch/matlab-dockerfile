# Copyright 2024 The MathWorks, Inc.

"""
Set of functions to parse the .md files
"""

from markdown_it import MarkdownIt
from pathlib import Path

def find_element(tree, target, path=[]):
    """
    Recursively searches for the target in the tree.
    
    :param tree: The current (sub)tree
    :param target: The target element to find
    :param path: The current path in the tree
    :return: The path to the target if found, else None
    """
    if target in tree:
        return path + [target]
    
    for key, subtree in tree.items():
        result = find_element(subtree, target, path + [key])
        if result:
            return result
    return None


def get_children(tree, path_to_target):
    """
    Retrieves the children of the target element in the tree.
    
    :param tree: The tree structure
    :param path_to_target: The path to the target element
    :return: A list of children of the target element
    """
    subtree = tree
    for step in path_to_target:
        subtree = subtree[step]  # Navigate to the target element
    return list(subtree.keys())  # The children are the keys of the target's subtree


def get_headings_tree(md_file_path):
    """
    Parses the headings of a .md file into a tree structure.

    :param md_file_path: Path to the .md file
    :return: The tree structure as a dictionary
    """

    # Read the Markdown file
    md_content = Path(md_file_path).read_text()

    # Initialize the Markdown parser
    md = MarkdownIt()

    # Parse the Markdown content
    tokens = md.parse(md_content)

    # Function to add a node to the tree
    def add_to_tree(tree, path, node):
        for part in path:
            tree = tree.setdefault(part, {})
        tree[node] = {}

    # Extract headings and their levels
    headings = [(token.tag, tokens[tokens.index(token) + 1].content) for token in tokens if token.type == 'heading_open']

    # Tree structure
    tree = {}

    # Current path in the tree
    path = []

    # Construct the tree
    for level, text in headings:
        level_num = int(level[-1])  # Convert 'h1', 'h2', etc. to a numeric level
        # Adjust the current path based on the level
        if level_num > len(path):
            path.append(text)  # Going deeper
        else:
            path = path[:level_num - 1] + [text]  # Moving to a different branch/same level
        add_to_tree(tree, path[:-1], path[-1])

    return tree
