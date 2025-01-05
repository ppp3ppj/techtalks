using System;

public class Option<T>
{
    private readonly T _value;
    public bool IsSome { get; }
    public bool IsNone => !IsSome;

    private Option(T value, bool isSome)
    {
        _value = value;
        IsSome = isSome;
    }

    public static Option<T> Some(T value)
    {
        if (value == null)
            throw new ArgumentNullException(nameof(value), "Cannot create an Option.Some with a null value.");
        return new Option<T>(value, true);
    }

    public static Option<T> None() => new Option<T>(default, false);

    public Option<TResult> Bind<TResult>(Func<T, Option<TResult>> binder)
    {
        if (binder == null)
            throw new ArgumentNullException(nameof(binder));
        return IsSome ? binder(_value) : Option<TResult>.None();
    }

    public T UnwrapOr(T defaultValue) => IsSome ? _value : defaultValue;

    public override string ToString() => IsSome ? $"Some({_value})" : "None";
}

public class Program
{
    public static Option<int> SafeDivide(int x, int y)
    {
        return y == 0 ? Option<int>.None() : Option<int>.Some(x / y);
    }

    public static void Main()
    {
        var result = SafeDivide(10, 2).Bind(x => SafeDivide(x, 0));

        if (result.IsNone)
        {
            Console.WriteLine("Error: Division by zero!");
        }
        else
        {
            Console.WriteLine($"Result: {result.UnwrapOr(0)}");
        }
    }
}
